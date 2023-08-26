import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/model/model.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Repository for work with database
/// saveMessage, getMessage, getMessages
class MessageRepository {
  /// Save the message in table
  bool saveMessage(Message message, ChatName chat) {
    try {
      ChatGpt chatGpt = ChatGpt(
          text: message.content,
          chatNameId: chat.id,
          date: message.date,
          role: message.role.name);

      chatGpt.save();
      return true;
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      return false;
    }
  }

  Future<List<ChatGpt>> getMessagesFromChat(ChatName chat) async {
    try {
      List<ChatGpt> messages =
          await ChatGpt().select().chatNameId.equals(chat.id).toList();
      return messages;
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      getIt<Talker>().info(
          'Произошла ошибка при попытки получить сообщения из чата, поэтому возвращаем пустой лист');
      return [];
    }
  }

  void deleteAll() {
    ChatGpt().select().delete();
  }

  /// Удаляет сообщения старше кол-ва дней [countDays]
  Future<bool> deleteMessagesOlderThan(int countDays) async {
    try {
      DateTime timeNow = DateTime.now();
      DateTime timeDifference = timeNow.subtract(Duration(days: countDays));
      var deleteResult =
          await ChatGpt().select().date.lessThan(timeDifference).delete();
      getIt<Talker>().info(deleteResult.toString());
      return deleteResult.success;
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      return false;
    }
  }

  Future<ChatGpt?> getLastSystemMessageFromChat(ChatName chatName) async {
    ChatGpt? message = await ChatGpt()
        .select()
        .chatNameId
        .equals(chatName.id)
        .and
        .role
        .equals('assistant')
        .orderByDesc('date')
        .toSingle();

    getIt<Talker>().good(
        'Find message ${message?.id} - ${message?.role} - ${message?.chatNameId} - ${message?.text} - ${message?.date}');
    return message;
  }
}
