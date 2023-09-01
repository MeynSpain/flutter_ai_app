import 'package:flutter/material.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/theme/extensions/message_composer.dart';
import 'package:flutter_ai/core/theme/extensions/message_input_container.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/model/model.dart';
import 'package:flutter_ai/generated/l10n.dart';
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
      duration: Duration(milliseconds: 500),
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
          padding:
              const EdgeInsets.only(left: 16, top: 10, right: 16, bottom: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: Color(0xFFF2F3F5),
                width: 2,
              ),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: themeMessageComposer!.boxDecoration,
            // height: 70,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled:
                        state.status == Status.sendingMessage ? false : true,
                    controller: _textController,
                    onSubmitted: (_) => _sendMessage(context, state),
                    textAlign: themeMessageComposer.textAlign,
                    style: themeMessageComposer.textStyle,
                    decoration: themeMessageComposer.inputDecoration.copyWith(
                      hintText: S.of(context).enterRequest,
                    ),
                  ),
                ),
                Visibility(
                  visible: _isTextNotEmpty,
                  child: Container(
                    width: 1.5,
                    height: 30,
                    color: Colors.black,
                  ),
                ),
                Visibility(
                  visible: _isTextNotEmpty,
                  child: IconButton(
                    onPressed: () => _sendMessage(context, state),
                    icon: SvgPicture.asset('assets/icons/send.svg'),
                  ),
                ),
              ],
            ),
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
