import 'package:flutter/material.dart';
import 'package:flutter_tags/src/text_util.dart';

typedef void OnDelete(String tags);
typedef void OnInsert(String tags);


class InputTags extends StatefulWidget{

    InputTags({
                       @required this.tags,
                       this.columns = 4,
                       this.autofocus,
                       this.inputDecoration,
                       this.maxLength,
                       this.keyboardType,
                       this.height,
                       this.borderRadius,
                       this.boxShadow,
                       this.placeholder,
                       this.symmetry = false,
                       this.margin,
                       this.padding,
                       this.alignment,
                       this.offset,
                       this.duplicate = false,
                       this.fontSize = 14,
                       this.iconSize,
                       this.iconPadding,
                       this.iconMargin,
                       this.iconColor,
                       this.iconBackground,
                       this.textOverflow,
                       this.textColor,
                       this.lowerCase = false,
                       this.color,
                       this.backgroundContainer,
                       this.highlightColor,
                       @required this.onDelete,
                       @required this.onInsert,
                       Key key
                   }) : assert(tags != null), assert(onDelete != null), assert(onInsert != null), super(key: key);

    ///List of [Tag] object
    final List<String> tags;

    ///specific number of columns
    final int columns;

    ///autofocus InputField
    final bool autofocus;

    ///decoration InputField
    final InputDecoration inputDecoration;

    ///max-length InputField
    final int maxLength;

    ///keyboard InputField
    final TextInputType keyboardType;

    ///customize the height of the [Tag]. Default auto-resize
    final double height;

    /// border-radius of [Tag]
    final double borderRadius;

    /// box-shadow of [Tag]
    final List<BoxShadow> boxShadow;

    ///placeholder InputField
    final String placeholder;

    /// imposes the same width and the same number of columns for each row
    final bool symmetry;

    /// margin between the [Tag]
    final EdgeInsets margin;

    /// padding of the [Tag]
    final EdgeInsets padding;

    /// type of row alignment
    final MainAxisAlignment alignment;

    /// offset of width (default 0)
    final int offset;

    /// possibility to insert duplicates in the list
    final bool duplicate;

    /// font size, the height of the [Tag] is proportional to the font size
    final double fontSize;

    /// icon size of Icon close
    final double iconSize;

    /// padding of Icon close
    final EdgeInsets iconPadding;

    /// margin of Icon close
    final EdgeInsets iconMargin;

    /// color of Icon close
    final Color iconColor;

    /// background of Icon close
    final Color iconBackground;

    /// type of text overflow within the [Tag]
    final TextOverflow textOverflow;

    /// text-color of the [Tag]
    final Color textColor;

    /// lower-case text [Tag]
    final bool lowerCase;

    /// background color [Tag]
    final Color color;

    /// background color container
    final Color backgroundContainer;

    ///highlight-color. it is activated when trying to insert a duplicate
    final Color highlightColor;

    /// callback
    final OnDelete onDelete;

    /// callback
    final OnInsert onInsert;



    @override
    _InputTagsState createState() => _InputTagsState();

}

class _InputTagsState extends State<InputTags>
{
    GlobalKey _containerKey = new GlobalKey();
    final _controller = TextEditingController();
    Orientation _orientation = Orientation.portrait;

    //duplicate highlighting
    int _check = -1;

    List<String> _tags = [];

    double _width = 0;
    double _initFontSize = 14;
    double _initMargin = 3;
    double _initPadding = 10;
    double _initBorderRadius = 50;

    double _initPaddingIcon = 3;
    double _initMarginIcon = 8;


    @override
    void initState()
    {
        super.initState();

        _tags = widget.tags;
    }


    @override
    void dispose()
    {
        _controller.dispose();
        super.dispose();
    }


    //get the current width of the container
    void _getwidthContainer()
    {
        WidgetsBinding.instance.addPostFrameCallback((_){
            final keyContext = _containerKey.currentContext;
            if (keyContext != null) {
                final RenderBox box = keyContext.findRenderObject ( );
                final size = box.size;
                setState(() {
                    _width = size.width;
                });
            }
        });
    }


    @override
    Widget build(BuildContext context)
    {
        // essential to avoid infinite loop of addPostFrameCallback
        if(MediaQuery.of(context).orientation != _orientation || _width==0)
            _getwidthContainer();
        _orientation = MediaQuery.of(context).orientation;

        return Container(
            key:_containerKey,
            margin: EdgeInsets.symmetric(vertical:5.0,horizontal:0.0),
            color: widget.backgroundContainer ?? Colors.white,
            child: Column( children: _buildRow(), ),
        );
    }


    List<Widget> _buildRow()
    {
        List<Widget> rows = [];

        int columns = widget.columns;

        //margin of the tag
        double margin = (widget.margin!=null)? widget.margin.horizontal : _initMargin*2;

        //padding of the tag
        double padding = widget.padding != null ? widget.padding.horizontal / 2 : _initPadding / 2;
        //padding = padding + padding / (_initPadding);

        int tagsLength = _tags.length+1;
        int rowsLength = (tagsLength/widget.columns).ceil();
        double fontSize = widget.fontSize ?? _initFontSize;

        //initial width tag
        double widthTag = 1;

        int start = 0;
        bool overflow;

        for(int i=0 ; i < rowsLength ; i++){

            // Single Row
            List<Widget> row = [];

            //break row
            overflow = false;

            //width of the Tag
            double tmpWidth = 0;

            // final index of the current row
            int end = start + columns;

            // makes sure that 'end' does not exceed 'tagsLength'
            if(end>=tagsLength) end -= end-tagsLength;

            for(int j=start  ; j < end ; j++ ){

                if(!widget.symmetry){

                    String tag = _tags[j%(tagsLength-1)];

                    TextSize txtSize = TextSize(
                        txt: tag,
                        fontSize: fontSize
                    );

                    double txtWidth = txtSize.get().width;

                    //sum of the width of each tag
                    //widget.offset it is optional but in special cases allows you to improve the width of the tags
                    //tmpWidth += txtWidth + margin + 15*( 1 + widget.fontSize/18) + padding + (widget.offset ?? 0);

                    tmpWidth += txtWidth + margin +  1.4*_widthIcon() + padding + (widget.offset ?? 0);

                    if (j > start && tmpWidth > _width){
                        start = j;
                        overflow = true;
                        rowsLength += 1;
                        break;
                    }

                    //for the correct display of the tag with a string of length less than 5, an offset is added
                    widthTag = txtWidth  + 1.4*_widthIcon() + padding ;
                }

                row.add( _buildField( index: _tags.isNotEmpty ? j%(tagsLength-1) : null, width: widthTag, last: (j+1 == tagsLength) ) );
            }

            // Check overflow width
            if(!overflow) start = end;

            rows.add(
                Row(
                    mainAxisAlignment: widget.alignment ?? ((widget.symmetry )? MainAxisAlignment.start : MainAxisAlignment.center),
                    children: row,
                )
            );
        }

        return rows;
    }



    Widget _buildField({int index, double width, bool last=false})
    {
        String tag = (index!=null )?_tags[index]:null;

        // for Flutter versions before 1.2
        // Currently they are indispensable for the correct functioning of TextField

        int c =0;
        String current = '';

        Widget textField = Flexible(
            flex: (widget.symmetry)? 1 : width.ceil(),
            child: Container(
                margin: widget.margin ?? EdgeInsets.symmetric(horizontal: _initMargin, vertical: 6),
                width: 200,
                child: TextField(
                    controller: _controller,
                    autofocus: widget.autofocus ?? true,
                    keyboardType: widget.keyboardType ?? null,
                    maxLength: widget.maxLength ?? null,
                    style: TextStyle(
                        fontSize: widget.fontSize ?? null,
                        color: Colors.black,
                    ),
                    decoration: widget.inputDecoration ?? InputDecoration(
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 7 +(widget.fontSize.clamp(10, 24).toDouble()-14),horizontal: 10 +(widget.fontSize.clamp(10, 24).toDouble()-14)),
                        hintText: widget.placeholder ?? 'Add a tag',
                        focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(widget.borderRadius ?? _initBorderRadius,),
                            borderSide: BorderSide(color: widget.color ?? Colors.green[400],),
                        ),
                        enabledBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(widget.borderRadius ?? _initBorderRadius,),
                            borderSide: BorderSide(color: Colors.green.withOpacity(0.5)),
                        ),
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(widget.borderRadius ?? _initBorderRadius,),
                            borderSide: BorderSide(color: Colors.green.withOpacity(0.5)),
                        )
                    ),
                    onChanged: (str) {

                        //Temporany --> textfield is not stable at the moment

                        str = (widget.lowerCase)? str.trim().toLowerCase(): str.trim();
                        setState(() {

                            if(c==1 && current==str && str!=''){
                                c++;
                                _check = -1;

                                if( _tags.contains(str) && !widget.duplicate )
                                    _check = _tags.indexWhere((st) => st==str);
                                else{
                                    widget.onInsert(str);
                                    _tags.add(str);
                                }

                                _controller.clear();
                            }
                            else if (c>1)
                                _controller.clear();

                            if(current!=str)
                                c++;

                            current = str;
                        });

                    },
                    onSubmitted: (str){
                        str = (widget.lowerCase)? str.trim().toLowerCase(): str.trim();
                        if(str!='')
                            setState(() {
                                _check = -1;
                                if(_tags.contains(str) && !widget.duplicate )
                                    _check = _tags.indexWhere((st) => st==str);
                                else{
                                    widget.onInsert(str);
                                    _tags.add(str);
                                }

                            });
                        _controller.clear();
                    },
                )
            )
        );

        if(last || tag==null)
            return textField;
        else
            return Flexible(
                flex: (widget.symmetry)? 1 : width.round(),
                child: Tooltip(
                    message: tag.toString(),
                    child: AnimatedContainer(
                        duration: _check==index? Duration(milliseconds: 80) : Duration(microseconds: 0),
                        margin: widget.margin ?? EdgeInsets.symmetric(horizontal: _initMargin, vertical: 6),
                        width: (widget.symmetry)? _widthCalc( ) : width,
                        height: widget.height ?? 4*(widget.fontSize/2),
                        decoration: BoxDecoration(
                            boxShadow: widget.boxShadow ?? [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 0.5,
                                    blurRadius: 4,
                                    offset: Offset(0, 1)
                                )
                            ],
                            borderRadius: BorderRadius.circular(widget.borderRadius ?? _initBorderRadius),
                            color: _check==index? ((widget.highlightColor ?? widget.color?.withRed(700)) ?? Colors.green.withRed(450)) : (widget.color ?? Colors.green[400]),
                        ),
                        child:Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                Flexible(
                                    fit: FlexFit.loose,
                                    flex: 1,
                                    child: Padding(
                                        padding: widget.padding ??  EdgeInsets.only(left: widget.symmetry? 15 :_initPadding),
                                        child: Text(
                                            tag,
                                            overflow: widget.textOverflow ?? TextOverflow.fade,
                                            softWrap: false,
                                            style: TextStyle(
                                                fontSize: widget.fontSize ?? null,
                                                color: widget.textColor ?? Colors.white,
                                                fontWeight: FontWeight.normal
                                            ),
                                        ),
                                    ),
                                ),
                                FittedBox(
                                    fit: BoxFit.cover,
                                    child: GestureDetector(
                                        child: Container(
                                            padding: widget.iconPadding  ?? EdgeInsets.all(_initPaddingIcon),
                                            margin: widget.iconMargin ??
                                                EdgeInsets.only(
                                                    right: _initMarginIcon *(widget.fontSize!=null? (widget.fontSize/20):1 )
                                                ),
                                            decoration: BoxDecoration(
                                                color: widget.iconBackground ?? Colors.transparent,
                                                borderRadius: BorderRadius.circular(widget.borderRadius ?? _initBorderRadius),
                                            ),
                                            child: Icon(
                                                Icons.clear,
                                                color: widget.iconColor ?? Colors.white,
                                                size: ((widget.fontSize!=null)? 15 +(widget.fontSize.clamp(6, 25).toDouble()-18) : 14)),
                                        ),
                                        onTap: (){
                                            _check = -1;
                                            widget.onDelete(tag);
                                            setState(() {
                                                _tags.remove(tag);
                                            });
                                        },
                                    )
                                )
                            ],
                        ),
                    )
                )
            );
    }

    ///total width of the close icon
    double _widthIcon()
    {
        double margin = widget.iconMargin!=null ?  widget.iconMargin.horizontal : _initMarginIcon;
        double padding = widget.iconPadding!=null ?  widget.iconPadding.horizontal/2 : _initPaddingIcon;
        double size =  (widget.fontSize!=null)? 15 +(widget.fontSize.clamp(6, 25).toDouble()-18) : 14;

        return margin + padding + size;
    }

    ///Container width divided by the number of columns when symmetry is active
    double _widthCalc()
    {
        int columns = widget.columns;

        int margin = (widget.margin!=null)? widget.margin.horizontal.round(): _initMargin.round()*2;

        int subtraction = columns *(margin);
        double width = ( _width>1 )? (_width-subtraction)/columns : _width;

        return width;
    }

}
