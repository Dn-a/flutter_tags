import 'package:flutter/material.dart';
import 'package:flutter_tags/src/text_util.dart';

/// Callback
typedef void OnPressed(Tag tags);

/// PopupMenuBuilder
typedef List<PopupMenuEntry> PopupMenuBuilder(Tag tag);
typedef void PopupMenuOnSelected(int id, Tag tag);

typedef Widget ItemBuilder(int index);

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
      this.itemBuilder,
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

  final ItemBuilder itemBuilder;

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
    _tags = widget.tags;
  }

  //get the current width of the container
  void _getwidth() {
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
      _getwidth();
      _orientation = MediaQuery.of(context).orientation;
    }

    //print("bulder selected");

    return (_width == 0)
        ? Container(key: _containerKey)
        : Container(
            //height: 38*(widget.fontSize.clamp(12, 30)/14), // only scrollDirextion: horizontal
            key: _containerKey,
            color: Colors.transparent,
            child: ListView(
              padding: EdgeInsets.all(0),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: _buildRow(),
            ),
          );
  }

  List<Widget> _buildRow() {
    List<Widget> rows = [];

    int columns = widget.columns;

    //double factor = 8*(widget.fontSize.clamp(7, 32)/15);

    int tagsLength = _tags.length;
    int rowsLength = (tagsLength / widget.columns).ceil();

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
        Item item = widget.itemBuilder(j);

        double fontSize = item.fontSize;

        //margin of the tag
        double margin = item.margin.horizontal;

        //padding of the tag
        double padding = item.padding.horizontal;
        padding = padding * (fontSize.clamp(8, 20) / 14);

        if (!widget.symmetry && _tags.isNotEmpty) {
          Item tag = widget.itemBuilder(j);

          //for tags with a string less than 2, or if there is an icon, the width is too small so i apply a slightly larger font size
          TextSize txtSize = TextSize(
              txt: item.title,
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

        row.add(Flexible(
            flex: (widget.symmetry) ? 0 : widthTag.round(),
            child: Container(
              margin: item.margin,
              width: (widget.symmetry) ? _widthCalc(item) : widthTag,
              height: item.height ?? 29 * (item.fontSize / 14),
              child: widget.itemBuilder(j),
            )));
      }

      // row overflow
      if (!overflow) start = end;

      rows.add(Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: widget.alignment ??
            ((widget.symmetry)
                ? MainAxisAlignment.start
                : MainAxisAlignment.center),
        children: row,
      ));
    }

    return rows;
  }

  List<Widget> _buildRowBack() {
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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
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
        //width: (widget.symmetry)? _widthCalc( index) : width,
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
            onPressed: () {
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

  /// Single item selection
  void _singleItem() {
    _tags.where((tg) => tg.active).forEach((tg) => tg.active = false);
  }

  ///Container width divided by the number of columns when symmetry is active
  double _widthCalc(Item item) {
    int columns = widget.columns;

    int margin = item.margin.horizontal.round();

    int subtraction = columns * (margin);
    double width = (_width > 1) ? (_width - subtraction) / columns : _width;

    return width;
  }

  ///Container width divided by the number of columns when symmetry is active
  double _widthCalcBack() {
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
  Tag({this.id, @required this.title, this.icon, this.active = true}) {
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

  @override
  String toString() {
    return '<TAG>\n id: $id;\n title: $title;\n active: $active;\n charsLength: $length\n<>';
  }
}

class Item extends StatelessWidget {
  Item(
      {this.id,
      @required this.title,
      this.icon,
      this.active = true,
      this.height,
      this.borderRadius,
      this.borderSide,
      this.boxShadow,
      this.symmetry = false,
      this.margin = const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
      this.padding = const EdgeInsets.symmetric(horizontal: 8),
      this.fontSize = 14,
      this.textStyle,
      this.textOverflow,
      this.textColor,
      this.textActiveColor,
      this.color,
      this.activeColor,
      this.onPressed,
      this.widget,
      Key key})
      : this.length = (icon != null) ? 2 : TextSize.utf8Length(title),
        super(key: key);

  final Widget widget;

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

  /// margin of  the [Tag]
  final EdgeInsets margin;

  /// padding of the [Tag]
  final EdgeInsets padding;

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

  /// callback
  final OnPressed onPressed;

  double _initPadding = 8;
  double _initBorderRadius = 50;

  final String id;
  final IconData icon;
  final String title;
  bool active;
  int length;

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          boxShadow: boxShadow ??
              [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0.5,
                    blurRadius: 4,
                    offset: Offset(0, 1))
              ],
          borderRadius:
              borderRadius ?? BorderRadius.circular(_initBorderRadius),
          color: active
              ? (activeColor ?? activeColor ?? Colors.blueGrey)
              : (color ?? color ?? Colors.white),
        ),
        child: OutlineButton(
            padding:
                (padding ?? EdgeInsets.symmetric(horizontal: _initPadding)) *
                    (fontSize.clamp(8, 20) / 14),
            color: active
                ? (activeColor ?? activeColor ?? Colors.blueGrey)
                : (color ?? color ?? Colors.white),
            highlightColor: Colors.transparent,
            highlightedBorderColor:
                activeColor ?? activeColor ?? Colors.blueGrey,
            //disabledTextColor: Colors.red,
            borderSide: borderSide ??
                BorderSide(
                    color: (activeColor ?? activeColor ?? Colors.blueGrey)),
            child: (icon != null)
                ? FittedBox(
                    child: Icon(
                      icon,
                      size: fontSize,
                      color: active
                          ? (textActiveColor ?? Colors.white)
                          : (textColor ?? Colors.black),
                    ),
                  )
                : Text(
                    title,
                    overflow: textOverflow ?? TextOverflow.fade,
                    softWrap: false,
                    style: _textStyle(),
                  ),
            onPressed: () {
              //if(widget.singleItem) _singleItem();

              /*setState(() {
                        (widget.singleItem)? active = true : active=!active;
                        if(onPressed != null)
                            onPressed(tag);
                    });*/
            },
            shape: RoundedRectangleBorder(
                borderRadius:
                    borderRadius ?? BorderRadius.circular(_initBorderRadius))));

    return Tooltip(
      message: title.toString(),
      child: container,
    );
  }

  ///TextStyle
  TextStyle _textStyle() {
    if (textStyle != null)
      return textStyle.apply(
        color: active
            ? (textActiveColor ?? Colors.white)
            : (textColor ?? Colors.black),
      );

    return TextStyle(
        fontSize: fontSize ?? null,
        color: active
            ? (textActiveColor ?? Colors.white)
            : (textColor ?? Colors.black),
        fontWeight: FontWeight.normal);
  }
}
