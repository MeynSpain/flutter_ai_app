import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/model/dto/chat.dart';
import 'package:flutter_ai/features/chat/widgets/confirm_dialog_widget.dart';
import 'package:flutter_ai/features/chat/widgets/create_new_chat_widget.dart';
import 'package:flutter_ai/features/chat/widgets/drawer_menu_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(
            left: 8,
          ),
          child: Text('Чаты'),
        ),
        actions: [
          Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: Icon(Icons.menu),
              ),
            );
          }),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Container(
            color: theme.primaryColor,
            height: 2,
          ),
        ),
      ),
      endDrawer: DrawerMenuWidget(),
      floatingActionButton: BlocBuilder<ChatBloc, ChatState>(
        bloc: getIt<ChatBloc>(),
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () => _onNewChatPressed(context, state),
            backgroundColor: theme.primaryColor,
            child: const Icon(Icons.add),
          );
        },
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        bloc: getIt<ChatBloc>(),
        builder: (context, state) {
          if (state.status == Status.chatsLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: theme.primaryColor,
            ));
          } else if (state.status == Status.error) {
            return Center(
              child: Text(
                'Что то пошло не так',
                style: theme.textTheme.bodyMedium,
              ),
            );
          } else {
            return ListView.separated(
              itemCount: state.chats.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 2,
                  color: theme.primaryColor,
                );
              },
              itemBuilder: (context, index) {
                int indexOf = state.chats[index].chatName.name!.indexOf('.');

                String chatName = // Чтобы самый новый чат был сверху
                    state.chats[state.chats.length - (index + 1)].chatName.name!
                        .substring(indexOf + 1);

                return ListTile(
                  // leading: IconButton(
                  //   icon: Icon(Icons.star_border),
                  //   onPressed: () {},
                  // ),
                  onTap: () => _selectChat(
                      state, state.chats[state.chats.length - (index + 1)]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_forever_rounded),
                    onPressed: () => _onDeleteChatPressed(
                        context, state.chats[state.chats.length - (index + 1)]),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(chatName, style: theme.textTheme.bodyLarge),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      state.chats[state.chats.length - (index + 1)].lastText ??
                          ' ',
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _selectChat(ChatState state, ChatDTO chat) {
    getIt<ChatBloc>().add(ChatSelectChatEvent(chat: chat));

    Navigator.pushNamed(context, '/chat');
  }

  void _onDeleteChatPressed(BuildContext context, ChatDTO chat) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialogWidget(
          chat: chat,
        );
      },
    );
  }

  void _onNewChatPressed(BuildContext context, ChatState state) {
    showDialog(
        context: context,
        builder: (context) {
          return BlocBuilder<ChatBloc, ChatState>(
            bloc: getIt<ChatBloc>(),
            builder: (context, state) {
              return const CreateNewChatWidget();
            },
          );
        });
  }
}
