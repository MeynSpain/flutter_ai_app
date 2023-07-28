import 'package:flutter_ai/core/injection.dart';
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
        role: message.role.name
      );

      chatGpt.save();
      return true;
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      return false;
    }
  }

  Future<List<ChatGpt>> getMessagesFromChat(ChatName chat)  async {
    List<ChatGpt> messages = await ChatGpt().select().chatNameId.equals(chat.id).toList();
    return messages;
  }

}
