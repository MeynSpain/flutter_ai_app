import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/status/status.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dart_openai/dart_openai.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        margin: isUser
                            ? const EdgeInsets.only(
                                top: 10, bottom: 10, left: 80, right: 10)
                            : const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 80),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFF3E40F0)
                              : const Color(0xFF181A21),
                          borderRadius: isUser
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                )
                              : const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                        ),
                        child: Text(state.messages[index].content),
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
