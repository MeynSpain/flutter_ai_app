import 'package:flutter/material.dart';

class UserMessageContainer extends ThemeExtension<UserMessageContainer> {
  final Color? color;
  final RoundedRectangleBorder? rectangleBorder;
  final BoxShadow? boxShadow;
  final TextStyle? textStyle;
  final EdgeInsets? margin;

  UserMessageContainer(
      {this.color,
      this.rectangleBorder,
      this.boxShadow,
      this.textStyle,
      this.margin});

  @override
  ThemeExtension<UserMessageContainer> copyWith() {
    return UserMessageContainer(
      color: color ?? this.color,
      rectangleBorder: rectangleBorder ?? this.rectangleBorder,
      boxShadow: boxShadow ?? this.boxShadow,
      textStyle: textStyle ?? this.textStyle,
      margin: margin ?? this.margin,
    );
  }

  @override
  ThemeExtension<UserMessageContainer> lerp(
      covariant ThemeExtension<UserMessageContainer>? other, double t) {
    return this;
  }
}
