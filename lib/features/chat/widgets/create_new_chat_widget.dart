import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/model/dto/chat.dart';
import 'package:flutter_svg/svg.dart';

class CreateNewChatWidget extends StatefulWidget {
  final String title;
  final bool isCreate;
  final ChatDTO? chat;

  const CreateNewChatWidget(
      {super.key, required this.title, required this.isCreate, this.chat});

  @override
  State<CreateNewChatWidget> createState() => _CreateNewChatWidgetState();
}

class _CreateNewChatWidgetState extends State<CreateNewChatWidget> {
  final TextEditingController _textCreateChatController =
      TextEditingController();

  bool _isTextNotEmpty = false;

  @override
  void initState() {
    super.initState();
    _textCreateChatController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textCreateChatController.removeListener(_onTextChanged);
    _textCreateChatController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTextNotEmpty = _textCreateChatController.text.isNotEmpty;
      print('########### LOG TEXT CONTROLLER : ${_isTextNotEmpty}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 150,
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.title,
              style: theme.textTheme.headlineMedium,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              padding: const EdgeInsets.only(left: 10, right: 0),
              margin: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 30,
                top: 30,
              ),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: theme.primaryColor,
                    )),
                // color: theme.primaryColor,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textCreateChatController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isTextNotEmpty,
                    child: IconButton(
                      onPressed: () {
                        // Выполните здесь необходимые действия с текстом из TextField
                        String text = _textCreateChatController.text.trim();
                        if (text.isNotEmpty) {
                          // Обработка нажатия кнопки
                          Navigator.of(context).pop();
                          if (widget.isCreate) {
                            getIt<ChatBloc>()
                                .add(ChatCreateNewChatEvent(chatName: text));
                            Navigator.of(context).pushNamed('/chat');
                          } else {
                            getIt<ChatBloc>().add(
                              ChatRenameChatNameEvent(name: text, chat: widget.chat!),
                            );
                          }
                        }
                      },
                      icon: SvgPicture.asset('assets/icons/create_chat.svg'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
