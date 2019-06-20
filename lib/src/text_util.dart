import 'dart:convert';
import 'package:flutter/material.dart';

class TextSize {
  String txt;
  TextAlign txtAlign;
  TextDirection txtDirection;
  double fontSize;
  double txtScaleFactor;
  int maxLine;

  TextSize(
      {@required this.txt,
      @required this.fontSize,
      this.txtAlign = TextAlign.left,
      this.txtDirection = TextDirection.ltr,
      this.txtScaleFactor = 1,
      this.maxLine = 1})
      : assert(txt != null),
        assert(fontSize != null);

  ///textPainter allows to obtain the size of the string after layout
  TextPainter get() {
    TextPainter txt = TextPainter(
        text: TextSpan(
          text: this.txt,
          style: TextStyle(
            fontSize: this.fontSize,
          ),
        ),
        textScaleFactor: this.txtScaleFactor,
        textDirection: this.txtDirection,
        textAlign: this.txtAlign,
        maxLines: this.maxLine);

    txt.layout();

    return txt;
  }

  ///length of character in the Unicode standard UTF8 (1 to 4 bytes long)
  static int utf8Length(String str) => utf8.encode(str).length;
}
