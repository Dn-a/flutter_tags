import 'package:flutter/material.dart';

// InputSuggestions version 0.0.1
// currently yield inline suggestions
// I will soon implement a list with suggestions
// Credit Dn-a -> https://github.com/Dn-a

/// Used by [SuggestionsTextField.onChanged].
typedef OnChangedCallback = void Function(String string);

/// Used by [SuggestionsTextField.onSubmitted].
typedef OnSubmittedCallback = void Function(String string);


class SuggestionsTextField extends StatefulWidget {
  SuggestionsTextField(
      {
        @required this.tagsTextFiled,
        this.onSubmitted,
        Key key})
      : assert(tagsTextFiled != null),
        super(key: key);

  final TagsTextFiled tagsTextFiled;
  final OnSubmittedCallback onSubmitted;

  @override
  _SuggestionsTextFieldState createState() => _SuggestionsTextFieldState();
}

class _SuggestionsTextFieldState extends State<SuggestionsTextField> {

  final _controller = TextEditingController();

  List<String> _matches = List();
  String _helperText;
  bool _helperCheck = true;

  List<String> _suggestions;
  double _fontSize;
  InputDecoration _inputDecoration;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    _helperText = widget.tagsTextFiled.helperText ?? "no matches";
    _suggestions = widget.tagsTextFiled.suggestions;
    _inputDecoration = widget.tagsTextFiled.inputDecoration;
    _fontSize = widget.tagsTextFiled.textStyle.fontSize;

    return Stack(
      children: <Widget>[
        Visibility(
          visible: _suggestions != null,
          child: Container(
            width: double.infinity,
            padding: _inputDecoration != null
                ? _inputDecoration.contentPadding
                : EdgeInsets.symmetric(
                vertical: 5 * (_fontSize/ 14),
                horizontal: 14 * (_fontSize/ 14)
            ),
            child: Text(
              _matches.isNotEmpty ? (_matches.first) : "",
              softWrap: false,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: _fontSize ?? null,
                color: widget.tagsTextFiled.suggestionTextColor ?? Colors.red,
              ),
            ),
          ),
        ),
        TextField(
          controller: _controller,
          autofocus: widget.tagsTextFiled.autofocus ?? true,
          keyboardType: widget.tagsTextFiled.keyboardType ?? null,
          maxLength: widget.tagsTextFiled.maxLength ?? null,
          maxLines: 1,
          autocorrect: widget.tagsTextFiled.autocorrect ?? false,
          style: widget.tagsTextFiled.textStyle.copyWith(height: 0.6 ),
          decoration: _initialInputDecoration,
          onChanged: (str) => _checkOnChanged(str),
          onSubmitted: (str) => _onSubmitted(str),
        )
      ],
    );
  }

  InputDecoration get _initialInputDecoration
  {
    var input = _inputDecoration ?? InputDecoration(
        disabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(
            vertical: 10 * (_fontSize/14),
            horizontal: 14 * (_fontSize/14)
        ),
        focusedBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(
            50,
          ),
          borderSide: BorderSide(
            color:  Colors.blueGrey[400],
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(
            50,
          ),
          borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.5)),
        ),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(
            50,
          ),
          borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.5)),
        ));

    return input.copyWith( helperText: _helperCheck || _suggestions==null ? null : _helperText,helperStyle: widget.tagsTextFiled.helperTextStyle, hintText: widget.tagsTextFiled.hintText ?? 'Add a tag',hintStyle: TextStyle(color: widget.tagsTextFiled.hintTextColor));
  }

  ///OnSubmitted
  void _onSubmitted(String str) {

    var onSubmitted = widget.onSubmitted;

    if (_suggestions != null) str = _matches.first;

    if (widget.tagsTextFiled.lowerCase) str = str.toLowerCase();

    str = str.trim();

    if (_suggestions != null) {
      if (_matches.isNotEmpty) {
        if (onSubmitted != null) onSubmitted(str);
        setState(() {
          _matches = [];
        });
        _controller.clear();
      }
    } else if (str.isNotEmpty) {
      if (onSubmitted != null) onSubmitted(str);
      _controller.clear();
    }
  }

  ///Check onChanged
  void _checkOnChanged(String str) {
    if(_suggestions!=null){
        _matches = _suggestions.where((String sgt) => sgt.startsWith(str)).toList();

        if (str.isEmpty) _matches = [];

        if (_matches.length > 1) _matches.removeWhere((String mtc) => mtc == str);

        setState(() {
          _helperCheck = _matches.isNotEmpty || str.isEmpty ? true : false;
          _matches.sort((a, b) => a.compareTo(b));
        });
    }

    if (widget.tagsTextFiled.onChanged != null) widget.tagsTextFiled.onChanged(str);
  }
}


enum TagsTextFiledPosition {
  start,
  end
}

/// Tags TextField
class TagsTextFiled {

  TagsTextFiled(
      {
        this.lowerCase = false,
        this.textStyle = const TextStyle(fontSize: 14),
        this.width = 200,
        this.duplicates = false,
        this.position = TagsTextFiledPosition.end,
        this.suggestions,
        this.autocorrect,
        this.autofocus,
        this.hintText,
        this.hintTextColor,
        this.suggestionTextColor,
        this.helperText,
        this.helperTextStyle,
        this.keyboardType,
        this.maxLength,
        this.inputDecoration,
        this.onSubmitted,
        this.onChanged
        });

  final double width;
  final bool duplicates;
  final TagsTextFiledPosition position;
  final TextStyle textStyle;
  final InputDecoration inputDecoration;
  final bool autocorrect;
  final List<String> suggestions;
  final bool lowerCase;
  final bool autofocus;
  final String hintText;
  final Color hintTextColor;
  final Color suggestionTextColor;
  final String helperText;
  final TextStyle helperTextStyle;
  final TextInputType keyboardType;
  final int maxLength;
  final OnSubmittedCallback onSubmitted;
  final OnChangedCallback onChanged;
}

