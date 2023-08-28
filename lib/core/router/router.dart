import 'package:flutter_ai/features/chat/view/view.dart';
import 'package:flutter_ai/features/settings/view/view.dart';

final routes = {
  '/': (context) => ChatsScreen(),
  '/chat': (context) => ChatScreen(),
  '/settings': (context) => SettingsScreen(),
  '/autoDeleting': (context) => AutoDeletingScreen(),
};
