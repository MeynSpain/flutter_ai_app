import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/model/message.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ChatGptService {

  static const contextLength = 4;


  Future<Message> getAnswer(List<Message> messages) {
    return _sendMessage(messages);
  }

  Future<Message> _sendMessage(List<Message> messages) async {
    List<Message> listContext = [];
    if (messages.length > contextLength) {
      listContext.addAll(messages.getRange(
          messages.length - contextLength, messages.length));
    }
    else {
      listContext = messages;
    }

    getIt<Talker>().log(listContext);

    OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat
        .create(
        model: "gpt-3.5-turbo",
        temperature: 0,
        maxTokens: 100,
        messages: List.generate(listContext.length,
                (index) =>
                OpenAIChatCompletionChoiceMessageModel(
                    content: listContext[index].content,
                    role: listContext[index].role,
                )
        )
    );

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
}