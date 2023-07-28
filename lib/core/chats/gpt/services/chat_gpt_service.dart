import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_ai/core/chats/gpt/repository/chat_name_repository.dart';
import 'package:flutter_ai/core/chats/gpt/repository/message_repository.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/model/message.dart';
import 'package:flutter_ai/features/chat/model/model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

class ChatGptService {
  final MessageRepository chatGptRepository = MessageRepository();
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
            maxTokens: 100,
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
    final apiKey = dotenv.env['apiKey'];
    OpenAI.apiKey = apiKey!;
    log('apiKey = $apiKey');
  }

  bool saveMessage(Message message, ChatName chat) {
    return chatGptRepository.saveMessage(message, chat);
  }

  Future<List<Message>> getMessagesFromChat(ChatName chat) async {
    List<ChatGpt> dataList = await chatGptRepository.getMessagesFromChat(chat);

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

  Future<ChatName?> createNewChat(String chatName) async {
    try {
      Uuid uuid = Uuid();
      String uuidName = uuid.v1() + '.' + chatName;
      ChatName? chat = await chatNameRepository.createNewChat(uuidName);
      return chat;
    } catch (e, st) {
      getIt<Talker>().handle(e, st);
      return null;
    }
  }

  Future<List<ChatName>> getChats() async {
    List<ChatName> chats = await chatNameRepository.getAllChatNames();
    return chats;
  }

  Future<ChatName?> getChatById(int id) async {
    ChatName? chat = await chatNameRepository.getChatById(id);
    return chat;
  }
}
