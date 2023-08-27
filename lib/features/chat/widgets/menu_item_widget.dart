import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuItemWidget extends StatelessWidget {
  final SvgPicture icon;
  final String caption;

  const MenuItemWidget({
    Key? key, // Исправлено ключевое слово key
    required this.icon,
    required this.caption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        log('########### Click $caption');
      },
      child: Ink( // Добавлен Ink внутри InkWell
        width: 260,
        height: 38,
        decoration: ShapeDecoration(
          color: Color(0xFFF7F7F7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), // Добавлено горизонтальное отступление
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              icon,
              const SizedBox(
                width: 10,
              ),
              Text(
                caption,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
