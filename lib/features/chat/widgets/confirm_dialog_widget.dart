import 'package:flutter/material.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/model/dto/chat.dart';

class ConfirmDialogWidget extends StatelessWidget {
  final ChatDTO chat;

  const ConfirmDialogWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Вы уверены что хотите удалить чат?',
              style: theme.textTheme.bodyMedium,
            ),
            // SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    getIt<ChatBloc>().add(ChatDeleteChatEvent(chat: chat));
                    Navigator.of(context).pop();
                  },
                  child: Text('Да'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    textStyle: theme.textTheme.bodyMedium,
                    side: BorderSide(
                      color: Colors.red,
                    ),
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Нет'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey,
                    textStyle: theme.textTheme.bodyMedium,
                    side: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                // OutlinedButton(onPressed: (){}, child: Text('No')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
