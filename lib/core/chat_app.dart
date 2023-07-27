import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/router/router.dart';
import 'package:flutter_ai/core/theme/theme.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ChatBloc>(),),

      ],
      child: MaterialApp(
        title: 'ChatGPT',
        theme: darkTheme,
        routes: routes,
      ),
    );
  }
}
