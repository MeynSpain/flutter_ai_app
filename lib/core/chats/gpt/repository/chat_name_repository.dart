import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/model/model.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ChatNameRepository {
  Future<List<ChatName>> getAllChatNames() async {
    var chats = await ChatName().select().orderBy('id').toList();
    return chats;
  }

  Future<ChatName?> getChatById(int id) async {
    ChatName? chat = await ChatName().getById(id);
    return chat;
  }

  Future<ChatName?> getChatByName(String name) async {
    ChatName? chat = await ChatName().select().name.equals(name).toSingle();
    return chat;
  }

  Future<ChatName?> createNewChat(String chatName) async {
    try {
      ChatName? chatFromDB =
          await ChatName().select().name.equals(chatName).toSingle();
      if (chatFromDB == null) {
        ChatName chat = ChatName();
        chat.name = chatName;
        chat.save();
        return getChatByName(chat.name!);
      } else {
        getIt<Talker>().error('Such a chat already exists');
        return null;
      }
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      return null;
    }
  }

  void deleteAll() {
    ChatName().select().delete();
  }

  Future<bool> deleteChat(ChatName chatName) async {
    try {
      var isDeleted = await chatName.delete();
      getIt<Talker>().info(isDeleted.toString());
      return isDeleted.success;
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      return false;
    }
  }

}
