import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerSettings extends StatefulWidget {
  const DrawerSettings({
    super.key,
  });

  @override
  State<DrawerSettings> createState() => _DrawerSettingsState();
}

class _DrawerSettingsState extends State<DrawerSettings> {
  late Days days;
  late int currentDays;

  Map<Days, String> captions = Map();

  @override
  void initState() {
    captions[Days.seven] = '7';
    captions[Days.fourteen] = '14';
    captions[Days.twentyOne] = '21';
    captions[Days.twentyEight] = '28';

    int? expiration =
    getIt<SharedPreferences>().getInt(PrefsNames.expirationDate);

    log('EXPITATION = ${expiration}' );
    currentDays = expiredDays;

    if (expiration != null) {
      switch (expiration) {
        case 7:
          days = Days.seven;
          break;
        case 14:
          days = Days.fourteen;
          break;
        case 21:
          days = Days.twentyOne;
          break;
        case 28:
          days = Days.twentyEight;
          break;
      }
    } else {
      days = Days.fourteen;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: Text(captions[Days.seven]!),
            leading: Radio<Days>(
              activeColor: Color(0xFFFFBF46),
              // fillColor: MaterialStateProperty.all(Colors.yellow),
              value: Days.seven,
              groupValue: days,
              onChanged: (Days? value) {
                setState(() {
                  days = value!;
                  currentDays = 7;
                  log('Current days = ${currentDays}');
                });
              },
            ),
          ),
          ListTile(
            title: Text(captions[Days.fourteen]!),
            leading: Radio<Days>(
              activeColor: Color(0xFFFFBF46),
              value: Days.fourteen,
              groupValue: days,
              onChanged: (Days? value) {
                setState(() {
                  days = value!;
                  currentDays = 14;
                  log('Current days = ${currentDays}');
                });
              },
            ),
          ),
          ListTile(
            title: Text(captions[Days.twentyOne]!),
            leading: Radio<Days>(
              activeColor: Color(0xFFFFBF46),
              value: Days.twentyOne,
              groupValue: days,
              onChanged: (Days? value) {
                setState(() {
                  days = value!;
                  currentDays = 21;
                  log('Current days = ${currentDays}');
                });
              },
            ),
          ),
          ListTile(
            title: Text(captions[Days.twentyEight]!),
            leading: Radio<Days>(
              activeColor: Color(0xFFFFBF46),
              value: Days.twentyEight,
              groupValue: days,
              onChanged: (Days? value) {
                setState(() {
                  days = value!;
                  currentDays = 28;
                  log('Current days = ${currentDays}');
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              getIt<SharedPreferences>()
                  .setInt(PrefsNames.expirationDate, currentDays);
              int? checkDays = getIt<SharedPreferences>()
                  .getInt(PrefsNames.expirationDate);
              if (checkDays != null) {
                log('Сменил Shared Preferens на ${checkDays} ');
              }
            },
            child: Text('Сохранить'),
          )
        ],
      ),
    );
  }
}
