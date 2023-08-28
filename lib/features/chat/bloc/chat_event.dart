part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

/// Отправка сообщения
class ChatSendMessageEvent extends ChatEvent {
  final Message message;

  ChatSendMessageEvent({required this.message});
}

/// Получение списка сообщений из базы данных
/// по текущему выбранному чату в стейте
class ChatGetMessagesEvent extends ChatEvent {}

/// Переключение текущего чата
class ChatSelectChatEvent extends ChatEvent {
  final ChatDTO? chat;

  ChatSelectChatEvent({this.chat});
}

/// Создание нового чата
class ChatCreateNewChatEvent extends ChatEvent {
  final String chatName;

  ChatCreateNewChatEvent({required this.chatName});
}

/// Загрузка списка всех чатов из базы данных
class ChatLoadChatsEvent extends ChatEvent {}

/// Получение чата из бд по id
class ChatGetChatByIdEvent extends ChatEvent {
  final int id;

  ChatGetChatByIdEvent({required this.id});
}

/// Удаление сообщений из базы данных с истекшим сроком годности
class ChatDeleteExpiredMessagesEvent extends ChatEvent {}

class ChatDeleteChatEvent extends ChatEvent {
  final ChatDTO chat;

  ChatDeleteChatEvent({required this.chat});
}

class ChatRenameChatNameEvent extends ChatEvent {
  final String name;
  final ChatDTO chat;

  ChatRenameChatNameEvent({required this.name, required this.chat});
}
