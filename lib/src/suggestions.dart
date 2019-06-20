import 'package:flutter/material.dart';

// InputSuggestions version 0.0.1
// currently yield inline suggestions
// I will soon implement a list with suggestions
// Credit Dn-a -> https://github.com/Dn-a

typedef void OnChanged(String string);
typedef void OnSubmitted(String string);

class InputSuggestions extends StatefulWidget {
  InputSuggestions(
      {this.fontSize = 14,
      this.lowerCase = false,
      this.style,
      this.suggestions,
      this.autocorrect,
      this.autofocus,
      this.keyboardType,
      this.maxLength,
      this.inputDecoration,
      this.onSubmitted,
      this.onChanged,
      Key key})
      : assert(fontSize != null),
        super(key: key);

  final TextStyle style;
  final InputDecoration inputDecoration;
  final double fontSize;
  final bool autocorrect;
  final List<String> suggestions;
  final bool lowerCase;
  final bool autofocus;
  final TextInputType keyboardType;
  final int maxLength;
  final OnSubmitted onSubmitted;
  final OnChanged onChanged;

  @override
  _InputSuggestionsState createState() => _InputSuggestionsState();
}

class _InputSuggestionsState extends State<InputSuggestions> {
  final _controller = TextEditingController();

  List<String> _matches = List();
  String _helperText = "no matches";
  bool _helperCheck = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Visibility(
          visible: widget.suggestions != null,
          child: Container(
            padding: widget.inputDecoration != null
                ? widget.inputDecoration.contentPadding
                : EdgeInsets.symmetric(
                    vertical: 10 + (widget.fontSize.toDouble() / 14),
                    horizontal: 0),
            child: Text(
              _matches.isNotEmpty ? (_matches.first) : "",
              softWrap: false,
              overflow: TextOverflow.fade,
              style: TextStyle(
                fontSize: widget.fontSize ?? null,
                color: Colors.red,
              ),
            ),
          ),
        ),
        TextField(
          controller: _controller,
          autofocus: widget.autofocus ?? true,
          keyboardType: widget.keyboardType ?? null,
          maxLength: widget.maxLength ?? null,
          maxLines: 1,
          autocorrect: widget.autocorrect ?? false,
          style: widget.style != null
              ? widget.style.copyWith(fontSize: widget.fontSize)
              : null,
          decoration: widget.inputDecoration != null
              ? (widget.suggestions != null
                  ? widget.inputDecoration.copyWith(
                      helperText: _helperCheck ? null : _helperText,
                    )
                  : widget.inputDecoration)
              : InputDecoration(
                  helperText: _helperCheck ? null : _helperText,
                ),
          onChanged: (str) => _checkOnChanged(str),
          onSubmitted: (str) => _onSubmitted(str),
        )
      ],
    );
  }

  ///OnSubmitted
  void _onSubmitted(String str) {
    if (widget.suggestions != null) str = _matches.first;

    if (widget.lowerCase) str = str.toLowerCase();

    str = str.trim();

    if (widget.suggestions != null) {
      if (_matches.isNotEmpty) {
        if (widget.onSubmitted != null) widget.onSubmitted(str);
        setState(() {
          _matches = [];
        });
        _controller.clear();
      }
    } else if (str.isNotEmpty) {
      if (widget.onSubmitted != null) widget.onSubmitted(str);
      _controller.clear();
    }
  }

  ///Check onChanged
  void _checkOnChanged(String str) {
    if (widget.suggestions != null) {
      var suggestions = widget.suggestions;
      _matches = suggestions.where((sgt) => sgt.startsWith(str)).toList();

      if (str.isEmpty) _matches = [];

      if (_matches.length > 1) _matches.removeWhere((mtc) => mtc == str);

      setState(() {
        _helperCheck = _matches.isNotEmpty || str.isEmpty ? true : false;
        _matches.sort((a, b) => a.compareTo(b));
      });

      if (widget.onChanged != null) widget.onChanged(str);
    }
  }
}
