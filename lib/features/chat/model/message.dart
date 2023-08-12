import 'package:dart_openai/dart_openai.dart';

class Message {
  late String _content;
  late String _author;
  late DateTime _date;
  late OpenAIChatMessageRole _role;

  Message({required OpenAIChatCompletionChoiceMessageModel message}) {
    _content = message.content;
    _author = message.role.name;
    _date = DateTime.now();
    _role = message.role;
  }

  Message.simple(
      {required content, required author, required date, required role}) {
    _content = content;
    _author = author;
    _date = date;
    switch (role) {
      case 'user':
        _role = OpenAIChatMessageRole.user;
        break;
      case 'assistant':
        _role = OpenAIChatMessageRole.assistant;
        break;
      case 'system':
        _role = OpenAIChatMessageRole.system;
        break;
    }
  }

  Message.fromUser({required content, required author}) {
    _content = content;
    _author = author;
    _date = DateTime.now();
    _role = OpenAIChatMessageRole.user;
  }

  Message.fromAI({required content}) {
    _content = content;
    _author = OpenAIChatMessageRole.assistant.toString();
    _date = DateTime.now();
    _role = OpenAIChatMessageRole.assistant;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get author => _author;

  set author(String value) {
    _author = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  OpenAIChatMessageRole get role => _role;

  set role(OpenAIChatMessageRole value) {
    _role = value;
  }

  @override
  String toString() {
    return 'Message{_content: $_content, _author: $_author, _date: $_date, _role: $_role}';
  }
}
