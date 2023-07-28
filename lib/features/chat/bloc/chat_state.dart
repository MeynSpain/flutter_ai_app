part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<Message> messages;
  final Status status;
  final List<ChatName> chats;

  const ChatState._({
    required this.messages,
    required this.status,
    required this.chats,
  });

  factory ChatState.initial() {
    return const ChatState._(
      messages: [],
      chats: [],
      status: Status.initial,
    );
  }

  ChatState copyWith({
    List<Message>? messages,
    List<ChatName>? chats,
    Status? status,
  }) {
    return ChatState._(
      messages: messages ?? this.messages,
      chats: chats ?? this.chats,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [messages, status, chats];
}
