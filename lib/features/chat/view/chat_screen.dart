import 'package:flutter/material.dart';
import 'package:flutter_ai/core/chats/gpt/gpt.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_ai/features/chat/model/model.dart';
import 'package:flutter_ai/features/chat/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatGptService service = ChatGptService();

  List<ChatName> chats = [];

  final CHAT_NAME = 'chat_main';

  @override
  void initState() {
    // getIt<ChatBloc>().add(ChatLoadChatsEvent());
    // getIt<ChatBloc>().add(ChatGetMessagesEvent());
    // getIt<ChatBloc>().add(ChatGetMessagesEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        String? chatName;
        if (state.selectedChat != null) {
          int indexOf = state.selectedChat!.name!.indexOf('.');

          chatName = // Чтобы самый новый чат был сверху
              state.selectedChat!.name!.substring(indexOf + 1);
        }
        return Scaffold(
          appBar: AppBar(
            title: chatName != null ? Text(chatName) : Text(''),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: SvgPicture.asset('assets/icons/list_chats_icon.svg'),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                );
              },
            ),
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                      icon: Icon(Icons.settings));
                },
              ),
            ],
          ),
          drawer: MyDrawerWithChats(),
          endDrawer: DrawerSettings(),
          body: SafeArea(
            child: Column(
              children: [
                ChatWidget(),
                MessageComposerWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
}
