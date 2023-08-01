import 'package:flutter/material.dart';
import 'package:flutter_ai/core/theme/extensions/bot_message_container.dart';
import 'package:flutter_ai/core/theme/extensions/message_composer.dart';
import 'package:flutter_ai/core/theme/extensions/user_message_container.dart';

final iconTheme = IconThemeData(
  color: Color.fromARGB(255, 0, 0, 0),
);

final mainTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 111, 218, 190),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(
        255,
        8,
        126,
        139,
      ),
      actionsIconTheme: iconTheme,
      iconTheme: iconTheme,
    ),
    primaryColor: const Color.fromARGB(
      255,
      8,
      126,
      139,
    ),
    extensions: <ThemeExtension<dynamic>>[
      MessageComposer(
        shapeDecoration: ShapeDecoration(
          color: const Color(0xFF6FDABE),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 0.50,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: Color(0xFF112A46),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0xFF000000),
              blurRadius: 0,
              offset: Offset(2, 2),
              spreadRadius: 0,
            )
          ],
        ),
        textAlign: TextAlign.center,
        textStyle: const TextStyle(
          color: Color(0xFF112A46),
          fontSize: 14,
          fontFamily: 'Noah',
          fontWeight: FontWeight.w500,
        ),
        inputDecoration: const InputDecoration(
            contentPadding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 16,
              bottom: 16,
            ),
            border: InputBorder.none,
            hintText: 'Text...',
            hintStyle: TextStyle(
              color: Color(0xCC112A46),
              fontSize: 14,
              fontFamily: 'Noah',
              fontWeight: FontWeight.w700,
            ),
        ),
      ),

///////////////////////////////////////////////

      UserMessageContainer(
        color: const Color(0xFFFCD581),
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 80, right: 10),
        rectangleBorder: const RoundedRectangleBorder(
          side: BorderSide(
            width: 0.50,
            strokeAlign: BorderSide.strokeAlignCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(2),
          ),
        ),
        boxShadow: const BoxShadow(
          color: Color(0xFF000000),
          blurRadius: 0,
          offset: Offset(4, 4),
          spreadRadius: 0,
        ),
        textStyle: const TextStyle(
          color: Color(0xFF112A46),
          fontSize: 14,
          fontFamily: 'Noah',
          fontWeight: FontWeight.w500,
        ),
      ),
      BotMessageContainer(
        color: const Color(0xFFFFA1C1),
        margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 80),
        rectangleBorder: const RoundedRectangleBorder(
          side: BorderSide(
            width: 0.50,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0xFF112A46),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(2),
            bottomRight: Radius.circular(30),
          ),
        ),
        boxShadow: const BoxShadow(
          color: Color(0xFF000000),
          blurRadius: 0,
          offset: Offset(4, 4),
          spreadRadius: 0,
        ),
        textStyle: const TextStyle(
          color: Color(0xFF112A46),
          fontSize: 14,
          fontFamily: 'Noah',
          fontWeight: FontWeight.w500,
        ),
      )
    ]);

final darkTheme = ThemeData(
// scaffoldBackgroundColor: const Color.fromARGB(255, 31, 31, 31),
  scaffoldBackgroundColor: const Color(0x000000),
  dividerColor: Colors.white24,
  primarySwatch: buildMaterialColor(Color(0xFF3E40F0)),

  appBarTheme: const AppBarTheme(
      backgroundColor: Color(0x0E1017),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      )),

// listTileTheme: const ListTileThemeData(iconColor: Colors.white),

  drawerTheme: DrawerThemeData(
    backgroundColor: const Color(0xFF0E1017),
  ),

  textTheme: TextTheme(
    bodyMedium: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 20,
    ),
    labelSmall: TextStyle(
      color: Colors.white.withOpacity(0.7),
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    headlineMedium: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 24,
    ),
  ),

// colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow,),
  useMaterial3: false,
);

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
