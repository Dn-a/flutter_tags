import 'dart:convert';

import 'package:flutter/material.dart';

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
                       this.onDelete,
                       this.onInsert,
                       Key key
                   }) : assert(tags != null), super(key: key);

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

    /// type of row alignment
    final MainAxisAlignment alignment;

    /// Different characters may have different widths
    /// With offset you can improve the automatic alignment of tags (default 28)
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
    double _initMargin = 3;
    double _initBorderRadius = 50;


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
            child: Column(
                children: _buildRow(),
            ),
        );
    }


    List<Widget> _buildRow()
    {
        List<Widget> rows = [];

        int columns = widget.columns;

        int margin = (widget.margin!=null)? widget.margin.horizontal.round(): _initMargin.round()*2;

        int tagsLength = _tags.length+1;
        int rowsLength = (tagsLength/widget.columns).ceil();
        double factor = 6.8*(widget.fontSize.clamp(7, 32)/15);
        double width = _width;//- columns *(_margin ?? 4);

        //compensates for the length of the string characters
        int offset = widget.offset ?? 35;

        int start = 0;
        bool overflow;

        for(int i=0 ; i < rowsLength ; i++){

            List<Widget> row = [];
            int charsLenght = 0 ;

            overflow = false;

            int end = start + columns;

            if(end>=tagsLength) end -= end-tagsLength;

            // Number of columns for each row
            int column = 1;
            if(!widget.symmetry && _tags.isNotEmpty){
                for(int j=start  ; j < end ; j++ ){
                    charsLenght += utf8.encode(_tags[j%(tagsLength-1)]).length;
                    double a = charsLenght * factor;

                    width = _width - (column * (margin + offset));
                    if(j>start && a>width) break;
                    column++;
                }
                charsLenght = 0;
            }

            for(int j=start  ; j < end ; j++ ){

                if(!widget.symmetry && _tags.isNotEmpty){
                    charsLenght += utf8.encode(_tags[j%(tagsLength-1)]).length;
                    double a = charsLenght * factor;
                    if( j>start && a>width ){
                        start = j;
                        overflow = true;
                        rowsLength +=1;
                        break;
                    }
                }

                row.add( _buildField( index: _tags.isNotEmpty ? j%(tagsLength-1) : null, column: column, last: (j+1 == tagsLength) ) );
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


    Widget _buildField({int index, int column, bool last=false})
    {
        String tag = (index!=null )?_tags[index]:null;

        // Currently they are indispensable for the correct functioning of TextField
        int c =0;
        String current = '';

        Widget textField = Flexible(
            flex: (widget.symmetry)? 1 : (14/(column+1) ).ceil(),
            child: Container(
                margin: widget.margin ?? EdgeInsets.symmetric(horizontal: _initMargin, vertical: 4),
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
                flex: (widget.symmetry)? 1 : ((utf8.encode(tag).length)/(column+0)+2).ceil(),
                child: Tooltip(
                    message: tag.toString(),
                    child: AnimatedContainer(
                        duration: _check==index? Duration(milliseconds: 80) : Duration(microseconds: 0),
                        margin: widget.margin ?? EdgeInsets.symmetric(horizontal: _initMargin, vertical: 4),
                        padding: EdgeInsets.only(left: widget.symmetry? 15 :12),
                        width: (widget.symmetry)? _widthCalc( ) : null,
                        height: widget.height ?? 31*(widget.fontSize/14),
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
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                Flexible(
                                    fit: FlexFit.loose,
                                    flex: 1,
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
                                FittedBox(
                                    fit: BoxFit.contain,
                                    child: GestureDetector(
                                        child: Container(
                                            padding: widget.iconPadding  ?? EdgeInsets.all(3),
                                            margin: widget.iconMargin ?? EdgeInsets.only(left:5, right: 5),
                                            decoration: BoxDecoration(
                                                color: widget.iconBackground ?? Colors.transparent,
                                                borderRadius: BorderRadius.circular(widget.borderRadius ?? _initBorderRadius),
                                            ),
                                            child: Icon(
                                                Icons.clear,color: widget.iconColor ?? Colors.white,
                                                size: widget.iconSize ?? ((widget.fontSize!=null)? 15 +(widget.fontSize.clamp(12, 24).toDouble()-18) : 14)),
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


    double _widthCalc()
    {
        int columns = widget.columns;

        int margin = (widget.margin!=null)? widget.margin.horizontal.round(): _initMargin.round()*2;

        int subtraction = columns *(margin);
        double width = ( _width>1 )? (_width-subtraction)/columns : _width;

        return width;
    }

}
