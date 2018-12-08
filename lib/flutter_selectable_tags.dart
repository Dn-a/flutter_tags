import 'package:flutter/material.dart';

typedef void OnPressed(Tag tags);


class SelectableTags extends StatefulWidget{

    SelectableTags({
                       @required this.tags,
                       this.columns = 4,
                       this.heigth,
                       this.borderRadius,
                       this.symmetry = false,
                       this.margin,
                       this.fontSize = 14,
                       this.maxLines,
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
    final double heigth;
    final double borderRadius;
    final bool symmetry;
    final EdgeInsets margin;
    final double fontSize;
    final int maxLines;
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

    double _width = 20;
    int _margin = null;


    @override
    void initState()
    {
        super.initState();

        _tags = widget.tags;

        if(widget.margin!=null) _margin = widget.margin.horizontal.round();

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
            child: Column(
                children: _buildRow(),
            ),
        );
    }


    List<Widget> _buildRow()
    {
        List<Widget> rows = [];

        int columns = widget.columns;

        int tagsLength = _tags.length;
        int rowsLength = _rowsLength(tagsLength: tagsLength);
        double factor = 9*(widget.fontSize/14);
        double width = _width - columns *(_margin ?? 10);

        var start = 0;
        for(int i=0 ; i < rowsLength ; i++){

            List<Widget> row = [];
            int charsLenght = 0 ;

            int end = start + columns;

            if(end>=tagsLength) end -= end-tagsLength;

            int column = 1;
            if(!widget.symmetry){
                for(int j=start  ; j < end ; j++ ){
                    charsLenght += _tags[j].length;
                    double a = charsLenght * factor;
                    if(a>width) break;
                    column++;
                }
                charsLenght = 0;
            }

            for(int j=start  ; j < end ; j++ ){

                if(!widget.symmetry){
                    charsLenght += _tags[j].length;
                    double a = charsLenght * factor;
                    start = j;
                    if(a>width && !widget.symmetry){
                        tagsLength+=columns-column;
                        //print(tagsLength);
                        rowsLength = _rowsLength(tagsLength: tagsLength);
                        break;
                    }
                }

                start = j+1;
                row.add( _buildField( index: j%tagsLength, row: i, column: column ) );
            }


            rows.add(
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
            flex: (widget.symmetry)? null : (_tags[index].length/column+3).ceil(),
            child: Tooltip(
                message: tag.title.toString(),
                child: Container(
                    margin: widget.margin ?? EdgeInsets.symmetric(horizontal:5.0,vertical:5.0),
                    width: (widget.symmetry)? _widthCalc( row: row ) : null,
                    height: widget.heigth ?? 34.0,
                    padding: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.borderRadius ?? 50.0),
                        color: tag.active? (widget.activeColor ?? Colors.green): (widget.color ?? Colors.white),
                    ),
                    child:OutlineButton(
                        color: widget.activeColor ?? Colors.green,
                        highlightColor: Colors.transparent,
                        highlightedBorderColor: Colors.transparent,
                        disabledTextColor: Colors.red,
                        borderSide: BorderSide(color: (widget.activeColor ?? Colors.green)),
                        child: Text(
                            tag.title,
                            maxLines: widget.maxLines ?? 1,
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.borderRadius ?? 50.0))
                    )
                ),
            )
        );
    }


    int _rowsLength({int tagsLength})
    {
        return (tagsLength/widget.columns).ceil();
    }


    double _widthCalc({int row})
    {
        int columns = widget.columns;
        //row+=1;
        //int fields = _tags.length - (columns*row) + columns;
        //int column = (fields < columns )? fields : columns;

        int subtraction = columns *(_margin ?? 10);
        double width = ( _width>1 )? (_width-subtraction)/columns : _width;

        return width;
    }

}



class Tag
{
    Tag({this.id, @required this.title, this.icon, this.active=true}){
        this.length = title.length;
    }

    final int id;
    final IconData icon;
    final String title;
    bool active;
    int length;


    @override
    String toString()
    {
        return 'id: ${id};\ntitle: ${title};\nactive: ${active};\ncharsLength: ${length}' ;
    }

}