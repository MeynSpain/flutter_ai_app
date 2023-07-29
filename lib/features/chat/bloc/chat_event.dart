part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatSendMessageEvent extends ChatEvent {
  final Message message;

  ChatSendMessageEvent({required this.message});
}

class ChatGetMessagesEvent extends ChatEvent {}

class ChatSelectChatEvent extends ChatEvent {
  final ChatName? chat;

  ChatSelectChatEvent({this.chat});
}

class ChatCreateNewChatEvent extends ChatEvent {
  final String chatName;

  ChatCreateNewChatEvent({required this.chatName});
}

class ChatLoadChatsEvent extends ChatEvent {}

class ChatGetChatByIdEvent extends ChatEvent {
  final int id;

  ChatGetChatByIdEvent({required this.id});
}
