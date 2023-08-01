import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/status/status.dart';
import 'package:flutter_ai/core/theme/extensions/message_composer.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageComposerWidget extends StatefulWidget {
  MessageComposerWidget({Key? key}) : super(key: key);

  @override
  State<MessageComposerWidget> createState() => _MessageComposerWidgetState();
}

class _MessageComposerWidgetState extends State<MessageComposerWidget> {
  final TextEditingController _textController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  bool _isTextNotEmpty = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTextNotEmpty = _textController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeMessageComposer = Theme.of(context).extension<MessageComposer>();
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(color: theme.primaryColor),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: themeMessageComposer!.shapeDecoration,
                  // height: 70,
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (_) => _sendMessage(context, state),
                    textAlign: themeMessageComposer.textAlign,
                    style: themeMessageComposer.textStyle,
                    decoration: themeMessageComposer.inputDecoration,
                  ),
                ),
              ),
              _isTextNotEmpty
                  ? Container(
                      decoration: ShapeDecoration(
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
                            offset: Offset(2, 2),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      margin: EdgeInsets.only(right: 12),
                      child: IconButton(
                        onPressed: () => _sendMessage(context, state),
                        icon: Transform.scale(
                          scale: 1.6,
                          child: SvgPicture.asset(
                            'assets/icons/send_icon.svg',
                            height: 44,
                            width: 44,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
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
