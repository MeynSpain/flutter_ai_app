import 'package:flutter/material.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/theme/extensions/bot_message_container.dart';
import 'package:flutter_ai/core/theme/extensions/user_message_container.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatWidget extends StatefulWidget {
  ChatWidget({Key? key}) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final ScrollController _scrollController = ScrollController();

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userTheme = Theme.of(context).extension<UserMessageContainer>();
    final botTheme = Theme.of(context).extension<BotMessageContainer>();
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: getIt<ChatBloc>(),
      builder: (context, state) {
        if (state.status == Status.success ||
            state.status == Status.responseReceived ||
            state.status == Status.sendingMessage) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            scrollToBottom();
          });
        }

        return state.status != Status.error
            ? Expanded(
                child: ListView.builder(
                  itemCount: state.messages.length,
                  controller: _scrollController,
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
                        child: MarkdownBody(
                          data: state.messages[index].content,
                          selectable: true,
                          // style: isUser
                          //     ? userTheme!.textStyle
                          //     : botTheme!.textStyle,
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
