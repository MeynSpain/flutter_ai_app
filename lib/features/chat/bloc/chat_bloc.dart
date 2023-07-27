import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/services/chat_gpt_service.dart';
import 'package:flutter_ai/core/status/status.dart';
import 'package:flutter_ai/features/chat/model/message.dart';
import 'package:meta/meta.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatGptService chatGptService;

  ChatBloc({required this.chatGptService}) : super(ChatState.initial()) {
    on<ChatSendMessageEvent>(_send);
  }

  FutureOr<void> _send(
      ChatSendMessageEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: Status.loading));

    try {
      // Отправка сообщения (контекст + новое)
      Message message =
          await chatGptService.getAnswer([...state.messages, event.message]);

      emit(state.copyWith(
          messages: [...state.messages, event.message, message],
          status: Status.success));

    } catch (e, st) {

      emit(state.copyWith(
          messages: [...state.messages, event.message],
          status: Status.error,
      ));

      getIt<Talker>().handle(e, st);
    }
  }
}
