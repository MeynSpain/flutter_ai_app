import 'package:flutter/material.dart';
import 'package:flutter_ai/features/chat/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  List<String> settingsList = ['Автоудаление'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Настройки'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Container(
            color: theme.primaryColor,
            height: 2,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: settingsList.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: ShapeDecoration(
              color: Color(0xFFF7F7F7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            margin: EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
            ),
            child: ListTile(
              leading: SvgPicture.asset('assets/icons/database.svg'),
              title: Text(
                settingsList[index],
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: 14,
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/autoDeleting');
              },
            ),
          );
        },
      ),
    );
  }
}
