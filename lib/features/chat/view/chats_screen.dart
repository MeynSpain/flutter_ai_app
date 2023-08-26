import 'package:flutter/material.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
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
        title: Text('Чаты'),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: Container(
            color: theme.primaryColor,
            height: 2,
          ),
        ),
      ),
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
            return const CircularProgressIndicator();
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
                  leading: IconButton(
                    icon: Icon(Icons.star_border),
                    onPressed: () {},
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {},
                  ),
                  title: Text(chatName, style: theme.textTheme.bodyLarge),
                  subtitle: Text(
                    state.chats[index].lastText ?? ' ',
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _selectChat(ChatState state, int index) {
    getIt<ChatBloc>().add(ChatSelectChatEvent(chat: state.chats[index]));
  }

  void _onNewChatPressed(BuildContext context, ChatState state) {
    showDialog(context: context, builder: (context) {
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
              Text('Новый чат'),
              Container(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10
                ),
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
                    )
                  ),
                  // color: theme.primaryColor,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
