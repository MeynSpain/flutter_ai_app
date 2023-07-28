part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatSendMessageEvent extends ChatEvent{
  final Message message;
  final ChatName chat;

  ChatSendMessageEvent({required this.message, required this.chat});
}

class ChatGetMessagesEvent extends ChatEvent{
  final ChatName? chat;

  ChatGetMessagesEvent({this.chat});
}

class ChatLoadChatsEvent extends ChatEvent {}


class ChatGetChatByIdEvent extends ChatEvent {
  final int id;

  ChatGetChatByIdEvent({required this.id});
}
