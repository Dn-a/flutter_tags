import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void OnDelete(String tags);


class InputTags extends StatefulWidget{

    InputTags({
                       @required this.tags,
                       this.columns = 4,
                       this.autofocus,
                       this.height,
                       this.borderRadius,
                       this.symmetry = false,
                       this.margin,
                       this.alignment,
                       this.duplicate = false,
                       this.fontSize = 14,
                       this.iconSize,
                       this.textOverflow,
                       this.textColor,
                       this.color,
                       this.backgroundContainer,
                       this.onDelete,
                       Key key
                   }) : super(key: key);

    final List<String> tags;
    final int columns;
    final bool autofocus;
    final double height;
    final double borderRadius;
    final bool symmetry;
    final bool duplicate;
    final EdgeInsets margin;
    final MainAxisAlignment alignment;
    final double fontSize;
    final double iconSize;
    final TextOverflow textOverflow;
    final Color textColor;
    final Color color;
    final Color backgroundContainer;
    final OnDelete onDelete;



    @override
    _InputTagsState createState() => _InputTagsState();

}

class _InputTagsState extends State<InputTags> with SingleTickerProviderStateMixin
{
    //AnimationController _aController;

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

        // Work in progress
        //_aController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    }


    @override
    void dispose() {
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
        double factor = 9.4*((widget.fontSize)/15);
        double width = _width - columns *(_margin ?? 10);

        int start = 0;
        bool overflow;

        for(int i=0 ; i < rowsLength ; i++){

            List<Widget> row = [];
            int charsLenght = 0 ;

            overflow = false;

            int end = start + columns;

            if(end>=tagsLength) end -= end-tagsLength;

            int column = 1;
            if(!widget.symmetry){
                for(int j=start  ; j < end ; j++ ){
                    charsLenght += _tags[j%(tagsLength-1)].length;
                    double a = charsLenght * factor;
                    if(j>start && a>width) break;
                    column++;
                }
                charsLenght = 0;
            }

            for(int j=start  ; j < end ; j++ ){

                if(!widget.symmetry){
                    charsLenght += _tags[j%(tagsLength-1)].length;
                    double a = charsLenght * factor;
                    if( j>start && a>width ){
                        start = j;
                        overflow = true;
                        rowsLength +=1;
                        break;
                    }
                }

                row.add( _buildField( index: j%(tagsLength-1), column: column, last: (j+1 == tagsLength) ) );
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
        String tag = _tags[index];

        // Currently they are indispensable for the correct functioning of TextField
        int c =0;
        String current = '';

        Color colorTag = widget.color ?? Colors.green;

        // Work in progress
        /*if(_check==index && !widget.duplicate){
            colorTag =
                ColorTween(begin: Colors.red, end: Colors.green).animate(CurvedAnimation(
                    parent: _aController,
                    curve: Interval(
                        0, 1,
                        curve: Curves.ease,
                    ),
                ),
                ).value;
            _aController.forward();
        }*/

        Widget textField = Flexible(
            flex: (widget.symmetry)? null : (18/column).ceil(),
            child: Container(
                padding: widget.margin ?? EdgeInsets.symmetric(horizontal:10,vertical:5.0),
                width: (widget.symmetry)? _widthCalc( ) : 200,
                child: TextField(
                    autofocus: widget.autofocus ?? true,
                    controller: _controller,
                    style: TextStyle(
                        fontSize: widget.fontSize ?? null,
                        color: Colors.black
                    ),
                    decoration: InputDecoration(
                        hintText: 'Add a tag'
                    ),
                    onChanged: (str) {
                        str = str.trim();

                        //temporary; textfield is not stable at the moment
                        setState(() {
                            if(c==1 && current==str && str!=''){
                                c++;
                                _check = -1;
                                if(_tags.contains(str))
                                    _check = _tags.indexWhere((st) => st==str);
                                else if (widget.duplicate)
                                    _tags.add(str);
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
                        str = str.trim();
                        if(str!='')
                            setState(() {
                                _check = -1;
                                if(_tags.contains(str) )
                                    _check = _tags.indexWhere((st) => st==str);
                                else if (widget.duplicate)
                                    _tags.add(str);
                                else
                                _tags.add(str);
                            });
                        _controller.clear();
                    },
                )
            )
        );

        if(last)
            return textField;
        else
            return Flexible(
                flex: (widget.symmetry)? 1 : ((_tags[index].length+3)/column+3).ceil(),
                child: Tooltip(
                    message: tag.toString(),
                    child: Container(
                        margin: widget.margin ?? EdgeInsets.symmetric(horizontal:2,vertical:2),
                        padding: EdgeInsets.only(left: 15),
                        width: (widget.symmetry)? _widthCalc( ) : null,
                        height: widget.height ?? 34.0*(widget.fontSize/14),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(widget.borderRadius ?? 3),
                            color: colorTag,
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
                                            color: Colors.white,
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
                    ),
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
