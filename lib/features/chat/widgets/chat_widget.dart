import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/status/status.dart';
import 'package:flutter_ai/core/theme/extensions/bot_message_container.dart';
import 'package:flutter_ai/core/theme/extensions/user_message_container.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dart_openai/dart_openai.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userTheme = Theme.of(context).extension<UserMessageContainer>();
    final botTheme = Theme.of(context).extension<BotMessageContainer>();
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: getIt<ChatBloc>(),
      builder: (context, state) {
        return state.status != Status.error
            ? Expanded(
                child: ListView.builder(
                  itemCount: state.messages.length,
                  itemBuilder: (context, int index) {
                    final bool isUser = state.messages[index].role ==
                        OpenAIChatMessageRole.user;

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: isUser ? userTheme!.margin : botTheme!.margin,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        decoration: ShapeDecoration(
                            color: isUser ? userTheme!.color : botTheme!.color,
                            shape: isUser
                                ? userTheme!.rectangleBorder
                                : botTheme!.rectangleBorder,
                            shadows: isUser
                                ? [
                                    userTheme!.boxShadow,
                                  ]
                                : [
                                    botTheme!.boxShadow,
                                  ]),
                        child: Text(
                          state.messages[index].content,
                          style: isUser
                              ? userTheme!.textStyle
                              : botTheme!.textStyle,
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
