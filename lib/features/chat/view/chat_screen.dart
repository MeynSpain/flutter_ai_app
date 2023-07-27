import 'package:flutter/material.dart';

import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/services/chat_gpt_service.dart';
import 'package:flutter_ai/core/status/status.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/model/message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Chat GPT',
        ),
      ),
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return Flexible(
                    child: ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          // color: Colors.amberAccent,
                          child: Text(state.messages[index].content),
                        );
                      },
                    ));
              },
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black12,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        onSubmitted: (_) => _sendMessage(context),
                        style: TextStyle(color: Colors.white),
                        controller: _textController,
                        decoration: InputDecoration.collapsed(
                            hintText: 'Send a message',
                            hintStyle: TextStyle(color: Colors.white)),
                      )),
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          _sendMessage(context);
                        },
                        icon: (state.status == Status.loading)
                            ? CircularProgressIndicator()
                            : const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    String text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(
        ChatSendMessageEvent(
            message: Message.fromUser(
                content: text, author: 'user')),
      );
    }
    _textController.text = '';
  }
}
