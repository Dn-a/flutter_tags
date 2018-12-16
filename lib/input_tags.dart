import 'package:flutter/material.dart';

typedef void OnDelete(String tags);


class InputTags extends StatefulWidget{

    InputTags({
                       @required this.tags,
                       this.columns = 4,
                       this.autofocus,
                       this.height,
                       this.borderRadius,
                       this.placeholder,
                       this.symmetry = false,
                       this.margin,
                       this.alignment,
                       this.offset,
                       this.duplicate = false,
                       this.fontSize = 14,
                       this.iconSize,
                       this.textOverflow,
                       this.textColor,
                       this.lowerCase = false,
                       this.color,
                       this.backgroundContainer,
                       this.highlightColor,
                       this.onDelete,
                       Key key
                   }) : super(key: key);

    final List<String> tags;
    final int columns;
    final bool autofocus;
    final double height;
    final double borderRadius;
    final String placeholder;
    final bool symmetry;
    final EdgeInsets margin;
    final MainAxisAlignment alignment;
    final int offset;
    final bool duplicate;
    final double fontSize;
    final double iconSize;
    final TextOverflow textOverflow;
    final Color textColor;
    final bool lowerCase;
    final Color color;
    final Color backgroundContainer;
    final Color highlightColor;
    final OnDelete onDelete;



    @override
    _InputTagsState createState() => _InputTagsState();

}

class _InputTagsState extends State<InputTags>
{
    GlobalKey _containerKey = new GlobalKey();
    final _controller = TextEditingController();
    int _check = -1;

    List<String> _tags = [];

    double _width = 1;
    int _margin;


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
    void dispose()
    {
        _controller.dispose();
        super.dispose();
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

        int tagsLength = _tags.length+1;
        int rowsLength = (tagsLength/widget.columns).ceil();
        double factor = 9.4*((widget.fontSize)/14);
        double width = _width;//- columns *(_margin ?? 4);

        //compensates for the length of the string characters
        int offset = widget.offset ?? 2;

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
                    charsLenght += _tags[j%(tagsLength-1)].length + offset;
                    double a = charsLenght * factor;

                    //total calculation of the margin of each field
                    width=_width- column *(_margin ?? 4);
                    if(j>start && a>width) break;

                    column++;
                }
                charsLenght = 0;
            }

            for(int j=start  ; j < end ; j++ ){

                if(!widget.symmetry && _tags.isNotEmpty){
                    charsLenght += _tags[j%(tagsLength-1)].length + offset;
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
        String tag = (index!=null)?_tags[index]:null;

        // Currently they are indispensable for the correct functioning of TextField
        int c =0;
        String current = '';

        Widget textField = Flexible(
            flex: (widget.symmetry)? 1 : (18/column).ceil(),
            child: Container(
                margin: widget.margin ?? EdgeInsets.symmetric(horizontal:2,vertical:2),
                width: 200,
                child: TextField(
                    autofocus: widget.autofocus ?? true,
                    controller: _controller,
                    style: TextStyle(
                        fontSize: widget.fontSize ?? null,
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                        hintText: widget.placeholder ?? 'Add a tag'
                    ),
                    onChanged: (str) {
                        //temporary; textfield is not stable at the moment
                        str = (widget.lowerCase)? str.trim().toLowerCase(): str.trim();
                        setState(() {

                            if(c==1 && current==str && str!=''){
                                c++;
                                _check = -1;
                                if( _tags.contains(str) && !widget.duplicate )
                                    _check = _tags.indexWhere((st) => st==str);
                                else
                                    _tags.add(str);

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
                                else
                                _tags.add(str);
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
                flex: (widget.symmetry)? 1 : ((_tags[index].length)/column+2).ceil(),
                child: Tooltip(
                    message: tag.toString(),
                    child: AnimatedContainer(
                        duration: _check==index? Duration(milliseconds: 50) : Duration(microseconds: 0),
                        margin: widget.margin ?? EdgeInsets.symmetric(horizontal:2,vertical:2),
                        padding: EdgeInsets.only(left: 15),
                        width: (widget.symmetry)? _widthCalc( ) : null,
                        height: widget.height ?? 34.0*(widget.fontSize/14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.borderRadius ?? 3),
                            color: _check==index? (widget.highlightColor ?? Colors.green[700]) : (widget.color ?? Colors.green),
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
                                    child: SizedBox(
                                        width: 40,
                                        child: IconButton(
                                            splashColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            icon: Icon(Icons.clear),
                                            color: widget.textColor ?? Colors.white,
                                            iconSize:  widget.iconSize ?? ((widget.fontSize!=null)? 18 +(widget.fontSize-18) : 18),
                                            onPressed: (){
                                                widget.onDelete(tag);
                                                setState(() {
                                                    _tags.remove(tag);
                                                });
                                            }
                                        ),
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

        int subtraction = columns *(_margin ?? 4);
        double width = ( _width>1 )? (_width-subtraction)/columns : _width;

        return width;
    }

}
