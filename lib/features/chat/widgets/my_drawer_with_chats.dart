import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/status/status.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MyDrawerWithChats extends StatelessWidget {
  MyDrawerWithChats({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Drawer(
      child: BlocBuilder<ChatBloc, ChatState>(
        bloc: getIt<ChatBloc>(),
        builder: (context, state) {
          if (state.status == Status.chatsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == Status.chatsLoading) {
            return Center(
              child: Text(
                'Something went wrong',
                style: theme.textTheme.bodyMedium,
              ),
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 35),
                  child: ElevatedButton(
                    onPressed: () {
                      _onNewChatPressed(context, state);
                    },
                    child: Text(
                      'New Chat',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                // Divider(),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      int indexOf = state.chats[index].name!.indexOf('.');
                      String chatName =
                          state.chats[index].name!.substring(indexOf + 1);
                      return ListTile(
                        title: Center(
                          child: Text(
                            chatName,
                            style: theme.textTheme.headlineMedium,
                          ),
                        ),
                        onTap: () => _selectChat(state, index),
                      );
                    },
                  ),
                ),
              ],
            );
          } // ELSE END
        },
      ),
    );
  }

  void _selectChat(ChatState state, int index) {
    getIt<ChatBloc>().add(ChatSelectChatEvent(chat: state.chats[index]));
  }

  void _onNewChatPressed(BuildContext context, ChatState state) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Creating new chat'),
          content: Container(
            height: 100,
            child: Column(
              children: [
                const Text('Write name of chat'),
                TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'New chat',
                  ),
                )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Выполните здесь необходимые действия с текстом из TextField
                String text = _textController.text.trim();
                if (text.isNotEmpty) {
                  // Обработка нажатия кнопки
                  Navigator.of(context).pop();
                  getIt<ChatBloc>().add(ChatCreateNewChatEvent(chatName: text));
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }
}
