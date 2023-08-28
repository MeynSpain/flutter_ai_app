import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/utils/prefs_utils.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial()) {
    on<SettingsSaveDaysEvent>(_saveDays);
  }

  FutureOr<void> _saveDays(
      SettingsSaveDaysEvent event, Emitter<SettingsState> emit) {

    getIt<PrefsUtils>().saveDays(state.daysList[event.daysIndex].intDay);
    emit(state.copyWith(selectedDaysIndex: event.daysIndex));
  }
}
