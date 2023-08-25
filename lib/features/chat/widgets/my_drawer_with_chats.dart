// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/theme/extensions/message_composer.dart';
import 'package:flutter_ai/core/theme/extensions/user_message_container.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/widgets/dialog_new_chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawerWithChats extends StatelessWidget {
  MyDrawerWithChats({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Drawer(
      backgroundColor: theme.primaryColor,
      child: BlocBuilder<ChatBloc, ChatState>(
        bloc: getIt<ChatBloc>(),
        builder: (context, state) {
          if (state.status == Status.chatsLoading) {
            return const Center(
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
                // ElevatedButton(
                //   onPressed: () {
                //     showDialog(context: context, builder: (context) {
                //       return DialogNewChat();
                //     });
                //   },
                //   child: Text('Test'),
                // ),
                // Divider(),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 2,
                      );
                    },
                    // reverse: true,
                    itemCount: state.chats.length,
                    itemBuilder: (context, index) {
                      int indexOf = state.chats[index].name!.indexOf('.');

                      String chatName = // Чтобы самый новый чат был сверху
                          state.chats[state.chats.length - (index + 1)].name!
                              .substring(indexOf + 1);

                      return ListTile(
                        title: Container(
                          decoration: ShapeDecoration(
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
                                offset: Offset(4, 4),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Center(
                            child: Text(
                              chatName,
                              style: theme.textTheme.headlineMedium,
                            ),
                          ),
                        ),
                        onTap: () => _selectChat(
                            state, state.chats.length - (index + 1)),
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
        final theme = Theme.of(context);
        final themeMessageComposer =
            Theme.of(context).extension<MessageComposer>();
        return AlertDialog(
          backgroundColor: theme.primaryColor,
          title: const Text('Creating new chat'),
          content: Container(
            // height: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius:  theme
                  .extension<UserMessageContainer>()!
                  .rectangleBorder
                  ?.borderRadius,
            ),
            child: Column(
              children: [
                const Text('Write name of chat'),
                Container(
                  height: 50,
                  decoration: themeMessageComposer!.shapeDecoration,
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'New chat',
                    ),
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
