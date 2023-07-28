import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/status/status.dart';
import 'package:flutter_ai/features/chat/model/message.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../core/chats/gpt/gpt.dart';
import '../model/model.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatGptService chatGptService;

  ChatBloc({required this.chatGptService}) : super(ChatState.initial()) {
    on<ChatSendMessageEvent>(_send);
    on<ChatGetMessagesEvent>(_get);
    on<ChatLoadChatsEvent>(_loadChats);
    on<ChatGetChatByIdEvent>(_getChatById);
  }

  /// Send message to chatGPT and get answer
  FutureOr<void> _send(
      ChatSendMessageEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: Status.loading));

    try {
      // Сохранение сообщения пользователя в бд
      chatGptService.saveMessage(event.message, event.chat);

      // Отправка сообщения (контекст + новое)
      Message message =
          await chatGptService.getAnswer([...state.messages, event.message]);

      emit(state.copyWith(
          messages: [...state.messages, event.message, message],
          status: Status.success));

      // Сохранение сообщения GPT в бд
      chatGptService.saveMessage(message, event.chat);
    } catch (e, st) {
      emit(state.copyWith(
        messages: [...state.messages, event.message],
        status: Status.error,
      ));

      getIt<Talker>().handle(e, st);
    }
  }

  /// Get all messages from database
  FutureOr<void> _get(
      ChatGetMessagesEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: Status.loading));

    try {
      ChatName? loadingChat = event.chat;
      if (loadingChat == null) {
        if (state.chats.isEmpty) {
          add(ChatLoadChatsEvent());
        }

        if (state.chats.isNotEmpty ||
            state.status == Status.chatsLoaded) {
          loadingChat = state.chats.last;
        }
      }

      // Если после всех проверок список чатов пуст, то создаем новый чат
      loadingChat ??= await chatGptService.createNewChat('chat');

      List<Message> messages =
          await chatGptService.getMessagesFromChat(loadingChat!);

      emit(state.copyWith(messages: messages, status: Status.success));
    } catch (e, st) {
      emit(state.copyWith(
        messages: [],
        status: Status.error,
      ));

      getIt<Talker>().handle(e, st);
    }
  }

  FutureOr<void> _loadChats(
      ChatLoadChatsEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: Status.loading));

    try {
      List<ChatName> chats = await chatGptService.getChats();

      emit(state.copyWith(
        chats: chats,
        status: Status.chatsLoaded,
      ));

      getIt<Talker>()
          .info('Chats were uploaded in the amount of ${chats.length} pieces');
    } catch (e, st) {
      emit(state.copyWith(
        status: Status.error,
      ));

      getIt<Talker>().handle(e, st);
    }
  }

  FutureOr<ChatName?> _getChatById(
      ChatGetChatByIdEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: Status.loading));

    try {
      ChatName? chat = await chatGptService.getChatById(event.id);

      if (chat == null) {
        emit(state.copyWith(
          status: Status.error,
        ));

        getIt<Talker>()
            .error('The chat for this id = ${event.id} was not found');
        return null;
      }

      emit(state.copyWith(
        status: Status.chatsLoaded,
      ));

      return chat;
    } catch (e, st) {
      emit(state.copyWith(
        chats: [...state.chats],
        status: Status.error,
      ));

      getIt<Talker>().handle(e, st);
    }
  }
}
