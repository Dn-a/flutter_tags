import 'package:flutter/material.dart';

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
                   }) : super(key: key);

    final List<Tag> tags;
    final int columns;
    final double height;
    final double borderRadius;
    final BorderSide borderSide;
    final List<BoxShadow> boxShadow;
    final bool symmetry;
    final EdgeInsets margin;
    final MainAxisAlignment alignment;
    final int offset;
    final double fontSize;
    final TextOverflow textOverflow;
    final Color textColor;
    final Color textActiveColor;
    final Color color;
    final Color activeColor;
    final Color backgroundContainer;
    final OnPressed onPressed;



    @override
    _SelectableTagsState createState() => _SelectableTagsState();

}

class _SelectableTagsState extends State<SelectableTags>
{

    GlobalKey _containerKey = new GlobalKey();

    List<Tag> _tags = [];

    double _width = 1;
    double _initMargin = 3;
    double _initBorderRadius = 50;


    @override
    void initState()
    {
        super.initState();

        _tags = widget.tags;

        //get the current width of the container
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

        int margin = (widget.margin!=null)? widget.margin.horizontal.round(): _initMargin.round()*2;

        int tagsLength = _tags.length;
        int rowsLength = (tagsLength/widget.columns).ceil();
        double factor = 9*(widget.fontSize.clamp(12, 24)/14);
        double width = _width;// - columns *(_margin ?? 10);

        //compensates for the length of the string characters
        int offset = widget.offset ?? 2;

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
                    charsLenght += _tags[j%tagsLength].length+offset;
                    double a = charsLenght * factor;

                    //total calculation of the margin of each field
                    width=_width - column *(margin);
                    if(j>start && a>width) break;
                    column++;
                }
                charsLenght = 0;
            }

            for(int j=start  ; j < end ; j++ ){

                if(!widget.symmetry){
                    charsLenght += _tags[j%tagsLength].length+offset;
                    double a = charsLenght * factor;
                    if( j>start && a>width ){
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
            flex: (widget.symmetry)? null : ((_tags[index].length)/column+1).ceil(),
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
                        color: widget.activeColor ?? Colors.blueGrey,
                        highlightColor: Colors.transparent,
                        highlightedBorderColor: Colors.transparent,
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
                            setState(() {
                                tag.active=!tag.active;
                                widget.onPressed(tag);
                            });
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? _initBorderRadius))
                    )
                ),
            )
        );
    }


    Widget _wrap()
    {
        List<Widget> list=[];

        _tags.forEach((tag){
            list.add(
                Tooltip(
                    message: tag.title.toString(),
                    child: Container(
                        margin: widget.margin ?? EdgeInsets.symmetric(horizontal: _initMargin, vertical: 6),
                        width: (widget.symmetry)? _widthCalc( ) : null,
                        height: widget.height ?? 31.0*(widget.fontSize/14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.borderRadius ?? _initBorderRadius),
                            color: tag.active? (widget.activeColor ?? Colors.green): (widget.color ?? Colors.white),
                        ),
                        child:OutlineButton(
                            color: widget.activeColor ?? Colors.green,
                            highlightColor: Colors.transparent,
                            highlightedBorderColor: Colors.transparent,
                            disabledTextColor: Colors.red,
                            borderSide: BorderSide(color: (widget.activeColor ?? Colors.green)),
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
                                setState(() {
                                    tag.active=!tag.active;
                                    widget.onPressed(tag);
                                });
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? _initBorderRadius))
                        )
                    ),
                )
            );

        });

        return Wrap(
            alignment: WrapAlignment.center,
            //runSpacing: 8,
            //spacing: 5,
            children: list,
        );
    }



    double _widthCalc({int row})
    {
        int columns = widget.columns;
        //row+=1;
        //int fields = _tags.length - (columns*row) + columns;
        //int column = (fields < columns )? fields : columns;

        int margin = (widget.margin!=null)? widget.margin.horizontal.round() : _initMargin.round()*2;

        int subtraction = columns *(margin);
        double width = ( _width>1 )? (_width-subtraction)/columns : _width;

        return width;
    }

}


class Tag
{
    Tag({this.id, @required this.title, this.icon, this.active=true}){
        this.length =  (icon!=null)? 1 : title.length;
    }

    final int id;
    final IconData icon;
    final String title;
    bool active;
    int length;


    @override
    String toString()
    {
        return '<TAG>\n id: ${id};\n title: ${title};\n active: ${active};\n charsLength: ${length}\n<>' ;
    }

}