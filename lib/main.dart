import 'package:flutter/material.dart';
import 'package:flutter_ai/core/chat_app.dart';
import 'package:flutter_ai/core/injection.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const ChatApp());
}
