part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatSendMessageEvent extends ChatEvent{
  final Message message;

  ChatSendMessageEvent({required this.message});
}

class ChatGetMessagesEvent extends ChatEvent{}

