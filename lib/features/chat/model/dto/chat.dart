import 'package:flutter_ai/features/chat/model/model.dart';

class ChatDTO {
  late ChatName _chatName;
  String? _lastText;

  ChatDTO({
    required chatName,
    lastText,
  }) {
    _chatName = chatName;
    _lastText = lastText;
  }

  String? get lastText => _lastText;

  ChatName get chatName => _chatName;

  set lastText(String? value) {
    _lastText = value;
  }

  set chatName(ChatName value) {
    _chatName = value;
  }
}
