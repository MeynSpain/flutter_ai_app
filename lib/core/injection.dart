
import 'package:flutter_ai/core/services/chat_gpt_service.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

/// Инстанс [GetIt]
final GetIt getIt = GetIt.instance;

const gpt_3_turbo = 'gpt-3.5-turbo';
const text_davinci = 'text-davinci-003';

Future<void> init() async {
  // Talker init
  final talker = TalkerFlutter.init();
  getIt.registerSingleton(talker);
  getIt<Talker>().info('Application started...');

  //Talker bloc logger
  Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printEventFullData: false,
        printStateFullData: false,
      ));

  ChatGptService chatGptService = ChatGptService();
  getIt.registerSingleton(chatGptService);


  // Register bloc
  getIt.registerLazySingleton<ChatBloc>(() => ChatBloc(chatGptService: getIt()));
}

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
