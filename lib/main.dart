import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


const gpt_3_turbo = 'gpt-3.5-turbo';
const text_davinci = 'text-davinci-003';

void main() async {
  await dotenv.load(fileName: '.env');
  final apiKey = dotenv.env['apiKey'];
  log('apiKey = $apiKey');

  OpenAI.apiKey = apiKey!;
  // OpenAI.baseUrl = 'https://api.openai.com/v1/chat/completions';
  // OpenAI.baseUrl = '/v1/chat/completions';
  // List<OpenAIModelModel> models = await OpenAI.instance.model.list();
  // OpenAIModelModel firstModel = models.first;

  // OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
  //   model: text_davinci,
  //   maxTokens: 10,
  //   n: 1,
  //   temperature: 0,
  //   messages: [
  //     OpenAIChatCompletionChoiceMessageModel(
  //       content: "hello, what is Flutter and Dart ?",
  //       role: OpenAIChatMessageRole.user,
  //     ),
  //   ],
  // );
  //
  // log('Ответ на вопрос');
  // log(chatCompletion.choices.first.message.content);

  // for(var model in models) {
  //   log('${model.id}');
  // }
  // print(firstModel.id); // .
  // print('Прошел список модеделей');
  // OpenAIModelModel model = await OpenAI.instance.model.retrieve("text-davinci-003");
  // print(model.id);
  // print('Прошла модель давинчи');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Text('Pusto'),
        // OpenAIStreamedCompletionBuilder(
        //     shouldRebuildOnStateUpdates: false,
        //     temperature: 0,
        //     n: 1,
        //     maxTokens: 100,
        //     model: text_davinci,
        //     prompt: "Hi",
        //     user: 'user',
        //     onSuccessBuilder: onSuccessBuilder,
        //     onErrorBuilder: onErrorBuilder,
        //     onLoadingBuilder: onLoadingBuilder,
        //    ),
      ),
    );
  }
  //
  // Widget onSuccessBuilder(BuildContext context, model) {
  //   return Text('success $model');
  // }
  //
  // Widget onErrorBuilder(BuildContext context, Object error) {
  //   return Text('Error');
  // }
  //
  // Widget onLoadingBuilder(BuildContext context) {
  //   return Text('Loading');
  // }
}
