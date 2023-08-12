import 'dart:developer';
import 'dart:io';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_ai/core/chats/gpt/repository/chat_name_repository.dart';
import 'package:flutter_ai/core/chats/gpt/repository/message_repository.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/model/message.dart';
import 'package:flutter_ai/features/chat/model/model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

class ChatGptService {
  final MessageRepository messageRepository = MessageRepository();
  final ChatNameRepository chatNameRepository = ChatNameRepository();

  static const contextLength = 4;

  Future<Message> getAnswer(List<Message> messages) {
    return _sendMessage(messages);
  }

  Future<Message> _sendMessage(List<Message> messages) async {
    List<Message> listContext = [];
    if (messages.length > contextLength) {
      listContext.addAll(
          messages.getRange(messages.length - contextLength, messages.length));
    } else {
      listContext = messages;
    }

    getIt<Talker>().log(listContext);

    OpenAIChatCompletionModel chatCompletion =
        await OpenAI.instance.chat.create(
            model: "gpt-3.5-turbo",
            temperature: 0,
            maxTokens: 1000,
            messages: List.generate(
                listContext.length,
                (index) => OpenAIChatCompletionChoiceMessageModel(
                      content: listContext[index].content,
                      role: listContext[index].role,
                    )));

    Message message = Message(message: chatCompletion.choices.first.message);
    getIt<Talker>().log(message);
    return message;
  }

  ChatGptService() {
    init();
  }

  // Инициализация сервиса
  Future<void> init() async {
    // Инициализация api ключа
    await dotenv.load(fileName: '.env');
    final apiKey = dotenv.env['apiKeyNew'];
    OpenAI.apiKey = apiKey!;
    log('apiKey = $apiKey');
  }

  bool saveMessage(Message message, ChatName chat) {
    return messageRepository.saveMessage(message, chat);
  }

  Future<List<Message>> getMessagesFromChat(ChatName chat) async {
    List<ChatGpt> dataList = await messageRepository.getMessagesFromChat(chat);

    List<Message> messages = List.generate(
        dataList.length,
        (index) => Message.simple(
            content: dataList[index].text,
            role: dataList[index].role,
            date: dataList[index].date,
            author: dataList[index].role));

    return messages;
  }

  /////// CHATS ////////

  Future<ChatName> createNewChat(String chatName) async {
    Uuid uuid = Uuid();
    String uuidName = uuid.v1() + '.' + chatName;
    ChatName? chat = await chatNameRepository.createNewChat(uuidName);

    if (chat == null) {
      throw Exception(
          'Something went wrong maybe a chat with this name already exists');
    }

    return chat;
  }

  Future<List<ChatName>> getChats() async {
    List<ChatName> chats = await chatNameRepository.getAllChatNames();
    return chats;
  }

  Future<ChatName?> getChatById(int id) async {
    ChatName? chat = await chatNameRepository.getChatById(id);
    return chat;
  }

  void deleteAllChats() {
    chatNameRepository.deleteAll();
  }

  void deleteAllMessages() {
    messageRepository.deleteAll();
  }

  Future<String?> getDatabasePath() async {
    final String? dbPath = await ChatGptDatabase().getDatabasePath();
    return '$dbPath/${ChatGptDatabase().databaseName}';
  }

  /// Get Size in bytes of database.
  /// If size == -1, then database not found
  Future<int> getDatabaseSize() async {
    final dbPath = await getDatabasePath();
    int dbSize = -1;

    if (dbPath != null) {
      File dbFile = File(dbPath);
      if (await dbFile.exists()) {
        FileStat dbStat = await dbFile.stat();
        dbSize = dbStat.size;
      }
    }

    return dbSize;
  }

  /// Удаляет сообщения с истекшим сроком годности.
  /// Срок годности берется из [SharedPreferences],
  /// зарегистрированного как Singleton с помощью [getIt]
  Future<bool> deleteExpiredMessages() async {
    bool isDeleted = false;

    int? expiration =
        getIt<SharedPreferences>().getInt(PrefsNames.expirationDate);

    getIt<Talker>().info('EXPITATION DAYS = ${expiration}');

    if (expiration != null) {
      isDeleted = await messageRepository.deleteMessagesOlderThan(expiration);
    }

    return isDeleted;
  }

  Future<bool> deleteChat(ChatName chat) async {
    bool isDeleted = await chatNameRepository.deleteChat(chat);
    return isDeleted;
  }
}
