part of 'chat_bloc.dart';

class ChatState extends Equatable {
  final List<Message> messages;
  final Status status;

  const ChatState._({required this.messages, required this.status});

  factory ChatState.initial() {
    return const ChatState._(messages: [], status: Status.initial);
  }

  ChatState copyWith({
    List<Message>? messages,
    Status? status,
  }) {
    return ChatState._(
        messages: messages ?? this.messages,
        status: status ?? this.status
    );
  }



  @override
  List<Object?> get props => [messages, status];
}
