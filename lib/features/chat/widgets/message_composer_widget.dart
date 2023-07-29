import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/status/status.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageComposerWidget extends StatelessWidget {
  MessageComposerWidget({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xAED2D7C5),
            borderRadius: BorderRadius.circular(20),
          ),
          // height: 70,
          child: TextField(
            controller: _textController,
            onSubmitted: (_) => _sendMessage(context, state),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              contentPadding:
              EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
              border: InputBorder.none,
              hintText: 'Введите текст',
              hintStyle: TextStyle(color: Colors.white, fontSize: 16),
              // icon: Icon(Icons.search, color: Colors.white), // Иконка справа от TextField
              // Указываем, что иконка должна находиться справа (end) и иметь отступ
              suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: state.status != Status.sendingMessage
                      ? IconButton(
                        onPressed: () => _sendMessage(context, state),
                        icon: SvgPicture.asset(
                            'assets/icons/arrow-chevron-right.svg'),
                      )
                      : const SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator()),
                // Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }

  void _sendMessage(BuildContext context, ChatState state) {
    String text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(
        ChatSendMessageEvent(
            message: Message.fromUser(content: text, author: 'user')),
      );
    }
    _textController.text = '';
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeOut,
    // );
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
