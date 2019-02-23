import 'dart:convert';

import 'package:flutter/material.dart';

/// Callback
typedef void OnPressed(Tag tags);


class SelectableTags extends StatefulWidget{

    SelectableTags({
                       @required this.tags,
                       this.columns = 4,
                       this.height,
                       this.borderRadius,
                       this.borderSide,
                       this.boxShadow,
                       this.symmetry = false,
                       this.singleItem = false,
                       this.margin,
                       this.alignment,
                       this.offset,
                       this.fontSize = 14,
                       this.textOverflow,
                       this.textColor,
                       this.textActiveColor,
                       this.color,
                       this.activeColor,
                       this.backgroundContainer,
                       this.onPressed,
                       Key key
                   }) : assert(tags != null), super(key: key);

    ///List of [Tag] object
    final List<Tag> tags;

    ///specific number of columns
    final int columns;

    ///customize the height of the [Tag]. Default auto-resize
    final double height;

    /// border-radius of [Tag]
    final double borderRadius;

    /// custom border-side of [Tag]
    final BorderSide borderSide;

    /// box-shadow of [Tag]
    final List<BoxShadow> boxShadow;

    /// imposes the same width and the same number of columns for each row
    final bool symmetry;

    /// when you want only one tag selected. same radio-button
    final bool singleItem;

    /// margin between the [Tag]
    final EdgeInsets margin;

    /// type of row alignment
    final MainAxisAlignment alignment;

    /// Different characters may have different widths
    /// With offset you can improve the automatic alignment of tags (default 28)
    final int offset;

    /// font size, the height of the [Tag] is proportional to the font size
    final double fontSize;

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



    @override
    _SelectableTagsState createState() => _SelectableTagsState();

}

class _SelectableTagsState extends State<SelectableTags>
{

    GlobalKey _containerKey = new GlobalKey();
    Orientation _orientation = Orientation.portrait;

    List<Tag> _tags = [];

    double _width =0;
    double _initMargin = 3;
    double _initBorderRadius = 50;


    @override
    void initState()
    {
        super.initState();
        _getwidthContainer();

        _tags = widget.tags;
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
            //child: _wrap()
            child: Column( children: _buildRow(), ),
        );
    }


    List<Widget> _buildRow()
    {
        List<Widget> rows = [];

        int columns = widget.columns;

        int margin = (widget.margin!=null)? widget.margin.horizontal.round() : _initMargin.round()*2;

        int tagsLength = _tags.length;
        int rowsLength = (tagsLength/widget.columns).ceil();
        double factor = 8*(widget.fontSize.clamp(7, 32)/15);
        double width = _width;// - columns *(_margin ?? 10);

        //compensates for the length of the string characters
        int offset = widget.offset ?? 28;

        int start = 0;
        bool overflow;

        for(int i=0 ; i < rowsLength ; i++){

            // Single Row
            List<Widget> row = [];

            int charsLenght = 0 ;
            overflow = false;

            // final index of the current column
            int end = start + columns;

            // makes sure that 'end' does not exceed 'tagsLength'
            if(end>=tagsLength) end -= end-tagsLength;

            int column = 0;
            if(!widget.symmetry){
                for(int j=start  ; j < end ; j++ ){
                    charsLenght += _tags[j%tagsLength].length;
                    double a = charsLenght * factor;

                    //total calculation of the margin of each field
                    width = _width - (column * (margin + offset));
                    if(j > start && a > width) break;
                    column++;
                }
                charsLenght = 0;
            }

            for(int j=start  ; j < end ; j++ ){

                if(!widget.symmetry){
                    charsLenght += _tags[j%tagsLength].length;
                    double a = charsLenght * factor;
                    if( j > start && a > width ){
                        start = j;
                        overflow = true;
                        rowsLength +=1;
                        break;
                    }
                }
                row.add( _buildField( index: j%tagsLength, row: i, column: column ) );
            }

            // check if the width of all the tags is greater
            if(!overflow) start = end;

            rows.add(
                Row(
                    mainAxisAlignment: widget.alignment ?? ((widget.symmetry)? MainAxisAlignment.start : MainAxisAlignment.center),
                    children: row,
                )
            );
        }
        return rows;
    }


    Widget _buildField({int index, int row, int column})
    {
        Tag tag = _tags[index];

        return Flexible(
            flex: (widget.symmetry)? null : ((tag.length)/(column+1)+1).ceil(),
            child: Tooltip(
                message: tag.title.toString(),
                child: Container(
                    margin: widget.margin ?? EdgeInsets.symmetric(horizontal: _initMargin, vertical:6),
                    width: (widget.symmetry)? _widthCalc( row: row ) : null,
                    height: widget.height ?? 31*(widget.fontSize/14),
                    padding: EdgeInsets.all(0.0),
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
                        color: tag.active? (widget.activeColor ?? Colors.blueGrey): (widget.color ?? Colors.white),
                    ),
                    child:OutlineButton(
                        color: tag.active? (widget.activeColor ?? Colors.blueGrey): (widget.color ?? Colors.white),
                        highlightColor: Colors.transparent,
                        highlightedBorderColor: widget.activeColor ?? Colors.blueGrey,
                        //disabledTextColor: Colors.red,
                        borderSide: widget.borderSide ?? BorderSide(color: (widget.activeColor ?? Colors.blueGrey)),
                        child:
                        (tag.icon!=null)?
                        FittedBox(
                            child: Icon(
                                tag.icon,
                                size: widget.fontSize,
                                color: tag.active? (widget.textActiveColor ?? Colors.white) : (widget.textColor ?? Colors.black),
                            ),
                        )
                            :
                        Text(
                            tag.title,
                            overflow: widget.textOverflow ?? TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                                fontSize: widget.fontSize ?? null,
                                color: tag.active? (widget.textActiveColor ?? Colors.white) : (widget.textColor ?? Colors.black),
                                fontWeight: FontWeight.normal
                            ),
                        ),
                        onPressed: () {

                            if(widget.singleItem) _singleItem();

                            setState(() {
                                (widget.singleItem)? tag.active = true : tag.active=!tag.active;
                                widget.onPressed(tag);
                            });

                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? _initBorderRadius))
                    )
                ),
            )
        );
    }


    /// Single item selection (same Radiobutton group HTML)
    void _singleItem()
    {
        _tags.where((tg) => tg.active).forEach((tg) => tg.active = false);
    }

    /// Single tag calculation
    double _widthCalc({int row})
    {
        int columns = widget.columns;
        //row+=1;
        //int fields = _tags.length - (columns*row) + columns;
        //int column = (fields < columns )? fields : columns;

        int margin = (widget.margin!=null)? widget.margin.horizontal.round() : _initMargin.round()*2;

        int subtraction = columns *(margin);
        double width = ( _width > 1 )? (_width-subtraction)/columns : _width;

        return width;
    }

}


class Tag
{
    Tag({this.id, @required this.title, this.icon, this.active=true}){
        //When an icon is set, the size is 2. it seemed the most appropriate
        this.length =  (icon!=null)? 2 : utf8.encode(title).length;
    }

    final int id;
    final IconData icon;
    final String title;
    bool active;
    int length;


    @override
    String toString()
    {
        return '<TAG>\n id: $id;\n title: $title;\n active: $active;\n charsLength: $length\n<>' ;
    }

}