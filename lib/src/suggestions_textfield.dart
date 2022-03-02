import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      {required this.tagsTextField, this.onSubmitted, Key? key})
      : assert(tagsTextField != null),
        super(key: key);

  final TagsTextField tagsTextField;
  final OnSubmittedCallback? onSubmitted;

  @override
  _SuggestionsTextFieldState createState() => _SuggestionsTextFieldState();
}

class _SuggestionsTextFieldState extends State<SuggestionsTextField> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> _matches = [];
  String? _helperText;
  bool _helperCheck = true;
  bool _hasFocus = false;

  List<String>? _suggestions;
  late bool _constraintSuggestion;
  double? _fontSize;
  InputDecoration? _inputDecoration;

  void _handleFocusChange() {
    //print('flutter_tags: _handleFocusChange _hasFocus=$_hasFocus _focusNode.hasFocus=${_focusNode.hasFocus}');
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void deactivate() {
    _focusNode.removeListener(_handleFocusChange);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _helperText = widget.tagsTextField.helperText ?? "no matches";
    _suggestions = widget.tagsTextField.suggestions;
    _constraintSuggestion = widget.tagsTextField.constraintSuggestion;
    _inputDecoration = widget.tagsTextField.inputDecoration;
    _fontSize = widget.tagsTextField.textStyle.fontSize;

    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Visibility(
          visible: _suggestions != null,
          child: Container(
            //width: double.infinity,
            padding: _inputDecoration != null
                ? _inputDecoration!.contentPadding
                : EdgeInsets.symmetric(
                    vertical: 6 * (_fontSize! / 14),
                    horizontal: 6 * (_fontSize! / 14)),
            child: Text(
              _matches.isNotEmpty ? (_matches.first) : "",
              softWrap: false,
              overflow: TextOverflow.fade,
              style: TextStyle(
                height: widget.tagsTextField.textStyle.height == null
                    ? 1
                    : widget.tagsTextField.textStyle.height,
                fontSize: _fontSize ?? null,
                color: widget.tagsTextField.suggestionTextColor ?? Colors.red,
              ),
            ),
          ),
        ),
        Actions(
          actions: {TabCompleteIntent: TabCompleteAction(textComplete: _matches.isNotEmpty ? (_matches.first) : "")},
          child: Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.tab): TabCompleteIntent(_controller, _focusNode)
            },
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              enabled: widget.tagsTextField.enabled,
              autofocus: widget.tagsTextField.autofocus ?? true,
              keyboardType: widget.tagsTextField.keyboardType ?? null,
              textCapitalization: widget.tagsTextField.textCapitalization ??
                  TextCapitalization.none,
              maxLength: widget.tagsTextField.maxLength ?? null,
              maxLines: 1,
              autocorrect: widget.tagsTextField.autocorrect ?? false,
              style: widget.tagsTextField.textStyle.copyWith(
                  height: widget.tagsTextField.textStyle.height == null ? 1 : null),
              decoration: _initialInputDecoration,
              onChanged: (str) => _checkOnChanged(str),
              onSubmitted: (str) => _onSubmitted(str),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration get _initialInputDecoration {
    var input = _inputDecoration ??
        InputDecoration(
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
                vertical: 6 * (_fontSize! / 14),
                horizontal: 6 * (_fontSize! / 14)),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blueGrey[300]!,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.blueGrey[400]!.withOpacity(0.3)),
            ),
            border: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.blueGrey[400]!.withOpacity(0.3)),
            ));

    return input.copyWith(
        helperText: _helperCheck || _suggestions == null ? null : _helperText,
        helperStyle: widget.tagsTextField.helperTextStyle,
        hintText: widget.tagsTextField.hintText ?? 'Add a tag',
        hintStyle: TextStyle(color: widget.tagsTextField.hintTextColor));
  }

  ///OnSubmitted
  void _onSubmitted(String str) {
    var onSubmitted = widget.onSubmitted;
    String original = str;
    if (_suggestions != null && _matches.isNotEmpty) str = _matches.first;

    if (widget.tagsTextField.lowerCase) str = str.toLowerCase();

    str = str.trim();

    if (!widget.tagsTextField.pickSuggestionOnEnter && original != str) {
      if (onSubmitted != null) onSubmitted(original);
      setState(() {
        _matches = [];
      });
      _controller.clear();
    } else if (_suggestions != null) {
      if (_matches.isNotEmpty || !_constraintSuggestion) {
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
    if (widget.tagsTextField.keepFocus && _hasFocus) {
      //print('flutter_tags: _onSubmitted keepFocus=${widget.tagsTextField.keepFocus}, _hasFocus=$_hasFocus');
      Future.delayed(Duration(milliseconds: 100), () {
        _focusNode.requestFocus();
      });
    }
  }

  ///Check onChanged
  void _checkOnChanged(String str) {
    if (_suggestions != null) {
      _matches =
          _suggestions!.where((String sgt) => sgt.startsWith(str)).toList();

      if (str.isEmpty) _matches = [];

      if (_matches.length > 1) _matches.removeWhere((String mtc) => mtc == str);

      setState(() {
        _helperCheck =
            _matches.isNotEmpty || str.isEmpty || !_constraintSuggestion
                ? true
                : false;
        _matches.sort((a, b) => a.compareTo(b));
      });
    }

    if (widget.tagsTextField.onChanged != null)
      widget.tagsTextField.onChanged!(str);
  }
}

/// Tags TextField
class TagsTextField {
  TagsTextField(
      {this.lowerCase = false,
      this.textStyle = const TextStyle(fontSize: 14),
      this.width = 200,
      this.padding,
      this.enabled = true,
      this.duplicates = false,
      this.suggestions,
      this.constraintSuggestion = true,
      this.pickSuggestionOnEnter = true,
      this.autocorrect,
      this.autofocus,
      this.keepFocus = false,
      this.hintText,
      this.hintTextColor,
      this.suggestionTextColor,
      this.helperText,
      this.helperTextStyle,
      this.keyboardType,
      this.textCapitalization,
      this.maxLength,
      this.inputDecoration,
      this.onSubmitted,
      this.onChanged});

  final double width;
  final EdgeInsets? padding;
  final bool enabled;
  final bool duplicates;
  final TextStyle textStyle;
  final InputDecoration? inputDecoration;
  final bool? autocorrect;
  final List<String>? suggestions;

  /// Allows you to insert tags not present in the list of suggestions
  final bool constraintSuggestion;
  final bool lowerCase;
  final bool pickSuggestionOnEnter;
  final bool? autofocus;
  final bool keepFocus;
  final String? hintText;
  final Color? hintTextColor;
  final Color? suggestionTextColor;
  final String? helperText;
  final TextStyle? helperTextStyle;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final int? maxLength;
  final OnSubmittedCallback? onSubmitted;
  final OnChangedCallback? onChanged;
}

class TabCompleteIntent extends Intent {
  const TabCompleteIntent(this.textController, this.focusNode);
  final TextEditingController textController;
  final FocusNode focusNode;
}

class TabCompleteAction extends Action {

  final String textComplete;

  TabCompleteAction({required this.textComplete});

  @override
  Object invoke(covariant Intent intent) {
    if (intent is TabCompleteIntent && textComplete != '') {
      intent.textController.value = TextEditingValue(text: textComplete);
      intent.textController.selection = TextSelection(
          baseOffset: textComplete.length,
          extentOffset: textComplete.length);
    } else if (intent is TabCompleteIntent) {
      intent.focusNode.nextFocus();
    }
    return '';
  }
}