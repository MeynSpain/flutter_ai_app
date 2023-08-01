import 'package:flutter/material.dart';

class MessageComposer extends ThemeExtension<MessageComposer> {
  final ShapeDecoration shapeDecoration;
  final TextAlign textAlign;
  final TextStyle textStyle;
  final InputDecoration inputDecoration;

  MessageComposer({
    required this.shapeDecoration,
    required this.textAlign,
    required this.textStyle,
    required this.inputDecoration,
  });

  @override
  ThemeExtension<MessageComposer> copyWith({
    ShapeDecoration? shapeDecoration,
    TextAlign? textAlign,
    TextStyle? textStyle,
    InputDecoration? inputDecoration,
  }) {
    return MessageComposer(
      shapeDecoration: shapeDecoration ?? this.shapeDecoration,
      textAlign: textAlign ?? this.textAlign,
      textStyle: textStyle ?? this.textStyle,
      inputDecoration: inputDecoration ?? this.inputDecoration,
    );
  }

  @override
  ThemeExtension<MessageComposer> lerp(
      covariant ThemeExtension<MessageComposer>? other, double t) {
    return this;
  }
}
