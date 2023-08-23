import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/features/chat/model/message.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../core/chats/gpt/gpt.dart';
import '../model/model.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatGptService chatGptService;
  
  final Message messageSending = Message.fromAI(content: 'Пишет...');
  final Message messageError = Message.fromAI(content: 'Произошла ошибка');

  ChatBloc({required this.chatGptService}) : super(ChatState.initial()) {
    on<ChatSendMessageEvent>(_send);
    on<ChatGetMessagesEvent>(_get);
    on<ChatLoadChatsEvent>(_loadChats);
    on<ChatGetChatByIdEvent>(_getChatById);
    on<ChatSelectChatEvent>(_selectChat);
    on<ChatCreateNewChatEvent>(_createNewChat);
    on<ChatDeleteExpiredMessagesEvent>(_deleteExpiredMessages);
    on<ChatDeleteChatEvent>(_deleteChat);
  }

  /// Send message to chatGPT and get answer
  FutureOr<void> _send(
      ChatSendMessageEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
      status: Status.sendingMessage,
      messages: [...state.messages, event.message, messageSending],
    ));

    try {
      // Сохранение сообщения пользователя в бд
      chatGptService.saveMessage(event.message, state.selectedChat!);

      // Отправка сообщения (контекст + новое)
      Message message =
          await chatGptService.getAnswer([...state.messages, event.message]);

      state.messages.removeLast();

      emit(state.copyWith(
          messages: [...state.messages, message],
          status: Status.responseReceived));

      // Сохранение сообщения GPT в бд
      chatGptService.saveMessage(message, state.selectedChat!);
    } catch (e, st) {
      state.messages.removeLast();
      emit(state.copyWith(
        messages: [...state.messages, event.message],
        status: Status.error,
      ));

      getIt<Talker>().handle(e, st);
    }
  }

  /// Get all messages by selected chat from database
  FutureOr<void> _get(
      ChatGetMessagesEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: Status.loading));

    try {
      if (state.selectedChat == null) {
        getIt<Talker>().error('Selected chat is NULL!!!!');
        emit(state.copyWith(
          status: Status.error,
        ));
        return;
      }

      List<Message> messages =
          await chatGptService.getMessagesFromChat(state.selectedChat!);

      emit(state.copyWith(messages: messages, status: Status.success));
    } catch (e, st) {
      emit(state.copyWith(
        messages: [],
        status: Status.error,
      ));

      getIt<Talker>().handle(e, st);
    }
  }

  /// Load chats from DB
  /// If there are no chats, then creates one
  FutureOr<void> _loadChats(
      ChatLoadChatsEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: Status.chatsLoading));

    try {
      List<ChatName> chats = await chatGptService.getChats();

      // Удаление сообщений с истекшим сроком годности
      // Пока во время загрузки чатов, мб потом в другое место уберу
      add(ChatDeleteExpiredMessagesEvent());

      ChatName? selectedChat;
      if (chats.isEmpty) {
        selectedChat = await chatGptService.createNewChat('New chat');
        chats.add(selectedChat);
      } else {
        selectedChat = chats.last;
      }

      emit(state.copyWith(
        chats: chats,
        selectedChat: selectedChat,
        status: Status.chatsLoaded,
      ));

      add(ChatGetMessagesEvent());

      getIt<Talker>()
          .info('Chats were uploaded in the amount of ${chats.length} pieces');
    } catch (e, st) {
      emit(state.copyWith(
        status: Status.error,
      ));

      getIt<Talker>().handle(e, st);
    }
  }

  /// Не используется
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

  FutureOr<void> _selectChat(
      ChatSelectChatEvent event, Emitter<ChatState> emit) {
    try {
      emit(state.copyWith(
        selectedChat: event.chat,
      ));

      add(ChatGetMessagesEvent());
    } catch (e, st) {
      emit(state.copyWith(status: Status.error));

      getIt<Talker>().handle(e, st);
    }
  }

  FutureOr<void> _createNewChat(
      ChatCreateNewChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
      status: Status.chatCreating,
    ));

    try {
      ChatName chat = await chatGptService.createNewChat(event.chatName);

      emit(state.copyWith(
        chats: [...state.chats, chat],
        status: Status.chatCreated,
      ));

      add(ChatSelectChatEvent(chat: chat));
    } catch (e, st) {
      emit(state.copyWith(status: Status.error));
      getIt<Talker>().handle(e, st);
    }
  }

  FutureOr<void> _deleteExpiredMessages(
      ChatDeleteExpiredMessagesEvent event, Emitter<ChatState> emit) async {
    await chatGptService.deleteExpiredMessages();
  }

  FutureOr<void> _deleteChat(
      ChatDeleteChatEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: Status.chatDeleting));

    try {
      await chatGptService.deleteChat(event.chat);

      if (event.chat == state.selectedChat) {
        state.messages.clear();
      }

      state.chats.remove(event.chat);

      emit(state.copyWith(status: Status.chatDeleted));
    } catch (e, st) {
      emit(state.copyWith(status: Status.error));
      getIt<Talker>().handle(e, st);
    }
  }
}
