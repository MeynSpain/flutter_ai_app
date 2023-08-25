import 'package:flutter/material.dart';
import 'package:flutter_ai/core/theme/extensions/message_composer.dart';
import 'package:flutter_ai/core/theme/extensions/message_input_container.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/model/model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageComposerWidget extends StatefulWidget {
  MessageComposerWidget({Key? key}) : super(key: key);

  @override
  State<MessageComposerWidget> createState() => _MessageComposerWidgetState();
}

class _MessageComposerWidgetState extends State<MessageComposerWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  late AnimationController _animationController;

  bool _isTextNotEmpty = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    );
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _animationController.dispose();
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
    final themeMessageComposer =
        Theme.of(context).extension<MessageInputContainer>();
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(
            left: 16,
            top: 10,
            right: 16,
            bottom: 16
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Color(0xFFF2F3F5))
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: themeMessageComposer!.boxDecoration,
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
                            color: Colors.red,
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
                      child: RotationTransition(
                        turns: Tween(begin: 0.0, end: 1.0)
                            .animate(_animationController),
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
    _animationController.forward();
    String text = _textController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(
            ChatSendMessageEvent(
                message: Message.fromUser(content: text, author: 'user')),
          );
    }
    _textController.text = '';
  }
}
