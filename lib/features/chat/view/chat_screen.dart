import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai/core/chats/gpt/gpt.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/status/status.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:flutter_ai/features/chat/model/message.dart';
import 'package:flutter_ai/features/chat/widgets/my_drawer_with_chats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../model/model.dart';
import '../widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatGptService service = ChatGptService();

  List<ChatName> chats = [];

  final CHAT_NAME = 'chat_main';

  @override
  void initState() {
    // getIt<ChatBloc>().add(ChatLoadChatsEvent());
    // getIt<ChatBloc>().add(ChatGetMessagesEvent());
    // getIt<ChatBloc>().add(ChatGetMessagesEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: SvgPicture.asset('assets/icons/list_chats_icon.svg'),
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      drawer: MyDrawerWithChats(),
      body: SafeArea(
        child: Column(
          children: [
            ChatWidget(),
            MessageComposerWidget(),
          ],
        ),
      ),
    );
  }
}

// child: Column(
//   // mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     BlocBuilder<ChatBloc, ChatState>(
//       builder: (context, state) {
//         return Flexible(
//             child: ListView.builder(
//           itemCount: state.messages.length,
//           itemBuilder: (BuildContext context, int index) {
//             return Container(
//               margin: const EdgeInsets.only(top: 10),
//               // color: Colors.amberAccent,
//               child: Text(state.messages[index].content),
//             );
//           },
//         ));
//       },
//     ),
//     Container(
//       decoration: const BoxDecoration(
//         color: Colors.black12,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//               child: TextField(
//             onSubmitted: (_) => _sendMessage(context),
//             style: TextStyle(color: Colors.white),
//             controller: _textController,
//             decoration: InputDecoration.collapsed(
//                 hintText: 'Send a message',
//                 hintStyle: TextStyle(color: Colors.white)),
//           )),
//           BlocBuilder<ChatBloc, ChatState>(
//             builder: (context, state) {
//               return IconButton(
//                 onPressed: () {
//                   _sendMessage(context);
//                 },
//                 icon: (state.status == Status.loading)
//                     ? CircularProgressIndicator()
//                     : const Icon(
//                         Icons.send,
//                         color: Colors.white,
//                       ),
//               );
//             },
//           ),
//         ],
//       ),
//     )
//   ],
// ),
// ),
// );

// void _sendMessage(BuildContext context) {
//   String text = _textController.text.trim();
//   if (text.isNotEmpty) {
//     context.read<ChatBloc>().add(
//           ChatSendMessageEvent(
//               chat: getIt<ChatBloc>().state.chats.last,
//               message: Message.fromUser(content: text, author: 'user')),
//         );
//   }
//   _textController.text = '';
//   _scrollController.animateTo(
//     _scrollController.position.maxScrollExtent,
//     duration: Duration(milliseconds: 300),
//     curve: Curves.easeOut,
//   );
// }
//
// Widget ChatBody() {
//   return Expanded(
//     child: BlocBuilder<ChatBloc, ChatState>(
//       builder: (context, state) {
//         chats = state.chats;
//         return MessageList(context: context, state: state);
//       },
//     ),
//   );
// }
//
// ListView MessageList(
//         {required BuildContext context, required ChatState state}) =>
//     ListView.builder(
//       controller: _scrollController,
//       itemCount: state.messages.length,
//       itemBuilder: (context, int index) {
//         return _buildMessage(state.messages[index]);
//       },
//     );
//
// Widget _buildMessage(Message message) {
//   final bool isUser = message.role == OpenAIChatMessageRole.user;
//   return Align(
//     alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//     child: Container(
//       margin: isUser
//           ? const EdgeInsets.only(top: 10, bottom: 10, left: 80, right: 10)
//           : const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 80),
//       padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
//       decoration: BoxDecoration(
//         color: isUser ? const Color(0xFF3E40F0) : const Color(0xFF181A21),
//         borderRadius: isUser
//             ? const BorderRadius.only(
//                 topLeft: Radius.circular(15),
//                 bottomLeft: Radius.circular(15),
//                 topRight: Radius.circular(15),
//               )
//             : const BorderRadius.only(
//                 topRight: Radius.circular(15),
//                 bottomRight: Radius.circular(15),
//                 topLeft: Radius.circular(15),
//               ),
//       ),
//       child: Text(message.content),
//     ),
//   );
// }
//
// Widget MessageComposer() {
//   return Container(
//     margin: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Color(0xAED2D7C5),
//       borderRadius: BorderRadius.circular(20),
//     ),
//     // height: 70,
//     child: TextField(
//       controller: _textController,
//       onSubmitted: (_) => _sendMessage(context),
//       textAlign: TextAlign.center,
//       style: TextStyle(color: Colors.white, fontSize: 16),
//       decoration: InputDecoration(
//         contentPadding:
//             EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
//         border: InputBorder.none,
//         hintText: 'Введите текст',
//         hintStyle: TextStyle(color: Colors.white, fontSize: 16),
//         // icon: Icon(Icons.search, color: Colors.white), // Иконка справа от TextField
//         // Указываем, что иконка должна находиться справа (end) и иметь отступ
//         suffixIcon: Padding(
//           padding: EdgeInsets.only(right: 10),
//           child: IconButton(
//             onPressed: () {
//               _sendMessage(context);
//             },
//             icon: SvgPicture.asset('assets/icons/arrow-chevron-right.svg'),
//           ),
//           // Icon(Icons.search, color: Colors.white),
//         ),
//       ),
//     ),

//       child: Row(
//         children: [
//           Expanded(
//               child: TextField(
//             onSubmitted: (_) => _sendMessage(context),
//             style: TextStyle(color: Colors.white),
//             controller: _textController,
//             decoration: InputDecoration.collapsed(
//                 hintText: 'Send a message',
//                 hintStyle: TextStyle(color: Colors.white)),
//           )),
//           BlocBuilder<ChatBloc, ChatState>(
//             builder: (context, state) {
//               return IconButton(
//                 onPressed: () {
//                   _sendMessage(context);
//                 },
//                 icon: (state.status == Status.loading)
//                     ? CircularProgressIndicator()
//                     : const Icon(
//                         Icons.send,
//                         color: Colors.white,
//                       ),
//               );
//             },
//           ),
//         ],
//       ),
//     )
//   ],
// ),
// );
