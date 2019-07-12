import 'package:flutter/material.dart';
import 'package:flutter_tags/src/text_util.dart';

/// Callback
typedef void OnPressed(Tag tags);

/// PopupMenuBuilder
typedef List<PopupMenuEntry> PopupMenuBuilder(Tag tag);
typedef void PopupMenuOnSelected(int id, Tag tag);

class SelectableTags extends StatefulWidget {
  SelectableTags(
      {@required this.tags,
      this.columns = 4,
      this.height,
      this.borderRadius,
      this.borderSide,
      this.boxShadow,
      this.symmetry = false,
      this.singleItem = false,
      this.margin,
      this.padding,
      this.alignment,
      this.offset,
      this.fontSize = 14,
      this.textStyle,
      this.textOverflow,
      this.textColor,
      this.textActiveColor,
      this.color,
      this.activeColor,
      this.backgroundContainer,
      this.onPressed,
      this.popupMenuBuilder,
      this.popupMenuOnSelected,
      this.inactiveTagSelectable = true,
      Key key})
      : assert(tags != null),
        super(key: key);

  ///List of [Tag] object
  final List<Tag> tags;

  ///specific number of columns
  final int columns;

  ///customize the height of the [Tag]. Default auto-resize
  final double height;

  /// border-radius of [Tag]
  final BorderRadius borderRadius;

  /// custom border-side of [Tag]
  final BorderSide borderSide;

  /// box-shadow of [Tag]
  final List<BoxShadow> boxShadow;

  /// imposes the same width and the same number of columns for each row
  final bool symmetry;

  /// when you want only one tag selected. same radio-button
  final bool singleItem;

  /// margin of  the [Tag]
  final EdgeInsets margin;

  /// padding of the [Tag]
  final EdgeInsets padding;

  /// type of row alignment
  final MainAxisAlignment alignment;

  /// To be used in combination with the padding (default 0)
  final int offset;

  /// font size, the height of the [Tag] is proportional to the font size
  final double fontSize;

  /// TextStyle of the [Tag]
  final TextStyle textStyle;

  /// type of text overflow within the [Tag]
  final TextOverflow textOverflow;

  /// text color of the [Tag]
  final Color textColor;

  /// color of the [Tag] text activated
  final Color textActiveColor;

  /// background color [Tag]
  final Color color;

  /// background color [Tag] activated
  final Color activeColor;

  /// background color container
  final Color backgroundContainer;

  /// callback
  final OnPressed onPressed;

  /// Popup Menu Items
  /// (Tag Tag)
  final PopupMenuBuilder popupMenuBuilder;

  /// On Selected Item
  /// (int id, Tag tag)
  final PopupMenuOnSelected popupMenuOnSelected;

  /// Defines if inactive tags can be selected
  final bool inactiveTagSelectable;

  @override
  _SelectableTagsState createState() => _SelectableTagsState();
}

class _SelectableTagsState extends State<SelectableTags> {
  GlobalKey _containerKey = new GlobalKey();
  Orientation _orientation = Orientation.portrait;

  // Position for popup menu
  Offset _tapPosition;

  List<Tag> _tags = [];

  double _width = 0;
  double _initFontSize = 14;
  double _initMargin = 3;
  double _initPadding = 8;
  double _initBorderRadius = 50;

  @override
  void initState() {
    super.initState();
    _getWidthContext();

    _tags = widget.tags;
  }

  //get the current width of the container
  void _getWidthContext() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyContext = _containerKey.currentContext;
      if (keyContext != null) {
        final RenderBox box = keyContext.findRenderObject();
        final size = box.size;
        setState(() {
          _width = size.width;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // essential to avoid infinite loop of addPostFrameCallback
    if (MediaQuery.of(context).orientation != _orientation || _width == 0) {
      _getWidthContext();
      _orientation = MediaQuery.of(context).orientation;

      //Avoid jitter/jump -> fix issue #14
      return Container(key: _containerKey);
    }

    return Container(
      key: _containerKey,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      color: widget.backgroundContainer ?? Colors.white,
      child: Column(
        children: _buildRow(),
      ),
    );
  }

  List<Widget> _buildRow() {
    List<Widget> rows = [];

    int columns = widget.columns;

    //margin of the tag
    double margin =
        (widget.margin != null) ? widget.margin.horizontal : _initMargin * 2;

    //padding of the tag
    double padding =
        widget.padding != null ? widget.padding.horizontal : _initPadding * 2;
    padding = padding * (widget.fontSize.clamp(8, 20) / 14);

    //double factor = 8*(widget.fontSize.clamp(7, 32)/15);

    int tagsLength = _tags.length;
    int rowsLength = (tagsLength / widget.columns).ceil();
    double fontSize = widget.fontSize ?? _initFontSize;

    //initial width tag
    double widthTag = 1;

    int start = 0;
    bool overflow;

    for (int i = 0; i < rowsLength; i++) {
      // Single Row
      List<Widget> row = [];

      //break row
      overflow = false;

      //width of the Tag
      double tmpWidth = 0;

      // final index of the current row
      int end = start + columns;

      // makes sure that 'end' does not exceed 'tagsLength'
      if (end >= tagsLength) end -= end - tagsLength;

      for (int j = start; j < end; j++) {
        if (!widget.symmetry && _tags.isNotEmpty) {
          Tag tag = _tags[j % tagsLength];

          //for tags with a string less than 2, or if there is an icon, the width is too small so i apply a slightly larger font size
          TextSize txtSize = TextSize(
              txt: tag.title,
              fontSize:
                  fontSize * (tag.length < 2 || tag.icon != null ? 1.4 : 1));

          // Total width of the tag
          double txtWidth = txtSize.get().width + margin + padding;

          //sum of the width of each tag
          //widget.offset it is optional but in special cases allows you to improve the width of the tags
          tmpWidth += txtWidth + (widget.offset ?? 0);

          if (j > start && tmpWidth > _width) {
            start = j;
            overflow = true;
            rowsLength += 1;
            break;
          }

          widthTag = txtWidth;
        }

        row.add(_buildField(index: j % tagsLength, width: widthTag));
      }

      // row overflow
      if (!overflow) start = end;

      rows.add(Row(
        mainAxisAlignment: widget.alignment ??
            ((widget.symmetry)
                ? MainAxisAlignment.start
                : MainAxisAlignment.center),
        children: row,
      ));
    }

    return rows;
  }

  Widget _buildField({int index, double width}) {
    Tag tag = _tags[index];

    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    Widget container = Container(
        margin: widget.margin ??
            EdgeInsets.symmetric(horizontal: _initMargin, vertical: 6),
        width: (widget.symmetry) ? _widthCalc() : width,
        height: widget.height ?? 29 * (widget.fontSize / 14),
        padding: EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          boxShadow: widget.boxShadow ??
              [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0.5,
                    blurRadius: 4,
                    offset: Offset(0, 1))
              ],
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(_initBorderRadius),
          color: tag.active
              ? (tag.activeColor ?? widget.activeColor ?? Colors.blueGrey)
              : (tag.color ?? widget.color ?? Colors.white),
        ),
        child: OutlineButton(
            padding: (widget.padding ??
                    EdgeInsets.symmetric(horizontal: _initPadding)) *
                (widget.fontSize.clamp(8, 20) / 14),
            color: tag.active
                ? (tag.activeColor ?? widget.activeColor ?? Colors.blueGrey)
                : (tag.color ?? widget.color ?? Colors.white),
            highlightColor: Colors.transparent,
            highlightedBorderColor:
                tag.activeColor ?? widget.activeColor ?? Colors.blueGrey,
            //disabledTextColor: Colors.red,
            borderSide: widget.borderSide ??
                BorderSide(
                    color: (tag.activeColor ??
                        widget.activeColor ??
                        Colors.blueGrey)),
            child: (tag.icon != null)
                ? FittedBox(
                    child: Icon(
                      tag.icon,
                      size: widget.fontSize,
                      color: tag.active
                          ? (widget.textActiveColor ?? Colors.white)
                          : (widget.textColor ?? Colors.black),
                    ),
                  )
                : Text(
                    tag.title,
                    overflow: widget.textOverflow ?? TextOverflow.fade,
                    softWrap: false,
                    style: _textStyle(tag),
                  ),
            onPressed: (!widget.inactiveTagSelectable && tag.active == false) ? null : () {
              if (widget.singleItem) _singleItem();

              setState(() {
                (widget.singleItem)
                    ? tag.active = true
                    : tag.active = !tag.active;
                if (widget.onPressed != null) widget.onPressed(tag);
              });
            },
            shape: RoundedRectangleBorder(
                borderRadius: widget.borderRadius ??
                    BorderRadius.circular(_initBorderRadius))));

    return Flexible(
        flex: (widget.symmetry) ? 0 : width.round(),
        child: GestureDetector(
          onTapDown: (details) {
            _tapPosition = details.globalPosition;
          },
          onLongPress: () {
            showMenu(
                    semanticLabel: tag.title,
                    items: widget.popupMenuBuilder(tag) ?? [],
                    context: context,
                    position: RelativeRect.fromRect(
                        _tapPosition & Size(40, 40),
                        Offset.zero &
                            overlay
                                .size) // & RelativeRect.fromLTRB(65.0, 40.0, 0.0, 0.0),
                    )
                .then((value) {
              if (widget.popupMenuOnSelected != null)
                widget.popupMenuOnSelected(value, tag);
            });
          },
          child: widget.popupMenuBuilder == null
              ? Tooltip(
                  message: tag.title.toString(),
                  child: container,
                )
              : container,
        ));
  }

  ///TextStyle
  TextStyle _textStyle(Tag tag) {
    if (widget.textStyle != null)
      return widget.textStyle.apply(
        color: tag.active
            ? (widget.textActiveColor ?? Colors.white)
            : (widget.textColor ?? Colors.black),
      );

    return TextStyle(
        fontSize: widget.fontSize ?? null,
        color: tag.active
            ? (widget.textActiveColor ?? Colors.white)
            : (widget.textColor ?? Colors.black),
        fontWeight: FontWeight.normal);
  }

  /// Single item selection (same Radiobutton group HTML)
  void _singleItem() {
    _tags.where((tg) => tg.active).forEach((tg) => tg.active = false);
  }

  ///Container width divided by the number of columns when symmetry is active
  double _widthCalc() {
    int columns = widget.columns;

    int margin = (widget.margin != null)
        ? widget.margin.horizontal.round()
        : _initMargin.round() * 2;

    int subtraction = columns * (margin);
    double width = (_width > 1) ? (_width - subtraction) / columns : _width;

    return width;
  }
}

class Tag {
  Tag(
      {this.id,
      @required this.title,
      this.icon,
      this.active = true,
      this.customData}) {
    //When an icon is set, the size is 2. it seemed the most appropriate
    this.length = (icon != null) ? 2 : TextSize.utf8Length(title);
  }

  final String id;
  final IconData icon;
  final String title;
  Color color;
  Color activeColor;
  bool active;
  int length;
  dynamic customData;

  @override
  String toString() {
    return '<TAG>\n id: $id;\n customData: $customData;\n title: $title;\n active: $active;\n charsLength: $length\n<>';
  }
}
