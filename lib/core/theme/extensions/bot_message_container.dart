import 'package:flutter/material.dart';

class BotMessageContainer extends ThemeExtension<BotMessageContainer> {
  final Color? color;
  final RoundedRectangleBorder? rectangleBorder;
  final BoxShadow? boxShadow;
  final TextStyle? textStyle;
  final EdgeInsets? margin;

  BotMessageContainer({
     this.color,
     this.rectangleBorder,
     this.boxShadow,
     this.textStyle,
     this.margin,
  });

  @override
  ThemeExtension<BotMessageContainer> copyWith({
    Color? color,
    RoundedRectangleBorder? rectangleBorder,
    BoxShadow? boxShadow,
    TextStyle? textStyle,
    EdgeInsets? margin,
  }) {
    return BotMessageContainer(
        color: color ?? this.color,
        rectangleBorder: rectangleBorder ?? this.rectangleBorder,
        boxShadow: boxShadow ?? this.boxShadow,
        textStyle: textStyle ?? this.textStyle,
        margin: margin ?? this.margin,
    );
  }

  @override
  ThemeExtension<BotMessageContainer> lerp(
      covariant ThemeExtension<BotMessageContainer>? other, double t) {
    return this;
  }
}
