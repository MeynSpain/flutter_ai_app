part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<Message> messages;
  final Status status;
  final List<ChatName> chats;
  final ChatName? selectedChat;

  const ChatState._({
    required this.messages,
    required this.status,
    required this.chats,
     this.selectedChat,
  });

  factory ChatState.initial() {
    return const ChatState._(
      messages: [],
      chats: [],
      selectedChat: null,
      status: Status.initial,
    );
  }

  ChatState copyWith({
    List<Message>? messages,
    List<ChatName>? chats,
    ChatName? selectedChat,
    Status? status,
  }) {
    return ChatState._(
      messages: messages ?? this.messages,
      chats: chats ?? this.chats,
      selectedChat: selectedChat ?? this.selectedChat,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [messages, status, chats, selectedChat];
}
