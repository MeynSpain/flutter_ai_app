import 'package:flutter/material.dart';

class MessageInputContainer extends ThemeExtension<MessageInputContainer> {
  final BoxDecoration boxDecoration;
  final TextAlign textAlign;
  final TextStyle textStyle;
  final InputDecoration inputDecoration;

  MessageInputContainer({
    required this.boxDecoration,
    required this.textAlign,
    required this.textStyle,
    required this.inputDecoration,
  });

  @override
  ThemeExtension<MessageInputContainer> copyWith({
    BoxDecoration? boxDecoration,
    TextAlign? textAlign,
    TextStyle? textStyle,
    InputDecoration? inputDecoration,
  }) {
    return MessageInputContainer(
      boxDecoration: boxDecoration ?? this.boxDecoration,
      textAlign: textAlign ?? this.textAlign,
      textStyle: textStyle ?? this.textStyle,
      inputDecoration: inputDecoration ?? this.inputDecoration,
    );
  }

  @override
  ThemeExtension<MessageInputContainer> lerp(
      covariant ThemeExtension<MessageInputContainer>? other, double t) {
    return this;
  }
}
