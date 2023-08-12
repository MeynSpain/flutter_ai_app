import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/features/chat/bloc/chat_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

import 'chats/gpt/gpt.dart';

/// Инстанс [GetIt]
final GetIt getIt = GetIt.instance;


const gpt_3_turbo = 'gpt-3.5-turbo';
const text_davinci = 'text-davinci-003';
const int expiredDays = 14;

Future<void> init() async {

  // Talker init
  final talker = TalkerFlutter.init();
  getIt.registerSingleton(talker);
  getIt<Talker>().info('Application started...');

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => prefs);

  int? days = prefs.getInt(PrefsNames.expirationDate);

  if (days == null) {
    prefs.setInt(PrefsNames.expirationDate, expiredDays);
  }

  talker.info('Expiration days = ${prefs.getInt(PrefsNames.expirationDate)}');


  ChatGptService chatGptService = ChatGptService();
  getIt.registerSingleton(chatGptService);

  // chatGptService.deleteAllMessages();
  // chatGptService.deleteAllChats();

  // Register ChatBloc
  getIt
      .registerLazySingleton<ChatBloc>(() => ChatBloc(chatGptService: getIt()));


  //Talker bloc logger
  Bloc.observer = TalkerBlocObserver(
      talker: talker,
      settings: const TalkerBlocLoggerSettings(
        printEventFullData: false,
        printStateFullData: true,
      ));

  getIt<ChatBloc>().add(ChatLoadChatsEvent());
}
