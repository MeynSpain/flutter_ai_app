import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: getIt<ChatBloc>(),
      builder: (context, state) {
        return Column(
          children: [
            ElevatedButton(
              onPressed: () {
                getIt<Talker>().info('Creating new chat');
              },
              child: const Text('New chat'),
            ),
            ListView.separated(
              itemCount: state.chats.length,
              separatorBuilder: (BuildContext context,
                  int index) => const Divider(),
              itemBuilder: (context, index) {
                int firstDot = state.chats[index].name!.indexOf('.');
                return ListTile(
                  title: Text(state.chats[index].name!.substring(firstDot + 1,)),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
