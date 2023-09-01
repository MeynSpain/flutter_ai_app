import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ai/features/chat/widgets/menu_item_widget.dart';
import 'package:flutter_ai/generated/l10n.dart';
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
            caption: S.of(context).settings,
            onTap: (){
              _onSettingsClick(context);
            },
          ),
          MenuItemWidget(
            icon: SvgPicture.asset('assets/icons/share.svg'),
            caption: S.of(context).share,
          ),
          MenuItemWidget(
            icon: SvgPicture.asset('assets/icons/star.svg'),
            caption: S.of(context).rateUs,
          ),
          MenuItemWidget(
            icon: SvgPicture.asset('assets/icons/sms.svg'),
            caption: S.of(context).contactUs,
          ),
          MenuItemWidget(
            icon: SvgPicture.asset('assets/icons/verified_user.svg'),
            caption: S.of(context).privacyPolicy,
          ),
          MenuItemWidget(
            icon: SvgPicture.asset('assets/icons/verified_user.svg'),
            caption: S.of(context).subscription,
            onTap: () {
              Navigator.pushNamed(context, '/subscribe');
            },
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  void _onSettingsClick(BuildContext context) {
    log('############### setting click #############');
    Navigator.pushNamed(context, '/settings');
  }


}
