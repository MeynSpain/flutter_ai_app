import 'package:flutter/material.dart';
import 'package:flutter_ai/features/chat/widgets/menu_item_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 245,
            height: 131,
            child: Stack(
              children: [
                SvgPicture.asset('assets/icons/logo.svg'),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Text(
                    'Anyq\nBot',
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          MenuItemWidget(
            icon: SvgPicture.asset('assets/icons/settings.svg'),
            caption: 'Настройки',
          ),
          MenuItemWidget(
            icon: SvgPicture.asset('assets/icons/share.svg'),
            caption: 'Поделиться',
          ),
          MenuItemWidget(
            icon: SvgPicture.asset('assets/icons/star.svg'),
            caption: 'Оценить нас',
          ),
          MenuItemWidget(
            icon: SvgPicture.asset('assets/icons/sms.svg'),
            caption: 'Связаться с нами',
          ),
          MenuItemWidget(
            icon: SvgPicture.asset('assets/icons/verified_user.svg'),
            caption: 'Политика\nконфиденциальности',
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
