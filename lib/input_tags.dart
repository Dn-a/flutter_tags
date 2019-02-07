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
                   }) : super(key: key);

    final List<String> tags;
    final int columns;
    final bool autofocus;
    final InputDecoration inputDecoration;
    final int maxLength;
    final TextInputType keyboardType;
    final double height;
    final double borderRadius;
    final List<BoxShadow> boxShadow;
    final String placeholder;
    final bool symmetry;
    final EdgeInsets margin;
    final MainAxisAlignment alignment;
    final int offset;
    final bool duplicate;
    final double fontSize;
    final double iconSize;
    final Color iconColor;
    final Color iconBackground;
    final TextOverflow textOverflow;
    final Color textColor;
    final bool lowerCase;
    final Color color;
    final Color backgroundContainer;
    final Color highlightColor;
    final OnDelete onDelete;
    final OnInsert onInsert;



    @override
    _InputTagsState createState() => _InputTagsState();

}

class _InputTagsState extends State<InputTags>
{
    GlobalKey _containerKey = new GlobalKey();
    final _controller = TextEditingController();

    //duplicate highlighting
    int _check = -1;

    List<String> _tags = [];

    double _width = 1;
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
        _getwidthContainer();
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
        double factor = 8.4*((widget.fontSize.clamp(8, 24))/14);
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
            int column = 0;
            if(!widget.symmetry && _tags.isNotEmpty){
                for(int j=start  ; j < end ; j++ ){
                    int length = _tags[j%(tagsLength-1)].length;
                    charsLenght += ( length < 3 ? 3:length) + offset;
                    double a = charsLenght * factor;

                    //total calculation of the margin of each field
                    width=_width- column *(margin);
                    if(j>start && a>width) break;

                    column++;
                }
                charsLenght = 0;
            }

            for(int j=start  ; j < end ; j++ ){

                if(!widget.symmetry && _tags.isNotEmpty){
                    int length = _tags[j%(tagsLength-1)].length;
                    charsLenght += ( length < 3 ? 3:length) + offset;
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
            flex: (widget.symmetry)? 1 : (18/ column!=0?column:1).ceil(),
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
                flex: (widget.symmetry)? 1 : ((_tags[index].length)/column+2).ceil(),
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
                                            padding: EdgeInsets.all(1),
                                            margin: EdgeInsets.only(left:5, right: 5),
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
