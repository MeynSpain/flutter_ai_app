import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ai/core/constant/constant.dart';
import 'package:flutter_ai/core/injection.dart';
import 'package:flutter_ai/core/utils/prefs_utils.dart';
import 'package:flutter_ai/generated/l10n.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState.initial()) {
    on<SettingsSaveDaysEvent>(_saveDays);
    on<SettingsAutoDeleteInitial>(_autoDeletingInitial);
  }

  FutureOr<void> _saveDays(
      SettingsSaveDaysEvent event, Emitter<SettingsState> emit) {
    getIt<PrefsUtils>().saveDays(state.daysList[event.daysIndex].intDay);
    emit(state.copyWith(selectedDaysIndex: event.daysIndex));
  }

  FutureOr<void> _autoDeletingInitial(
      SettingsAutoDeleteInitial event, Emitter<SettingsState> emit) {
    emit(
      state.copyWith(
        daysList: daysSettingsList(event.context),
      ),
    );
  }

  List<DayPair> daysSettingsList(BuildContext context) => [
        DayPair(intDay: 1, literalDay: S.of(context).day),
        DayPair(intDay: 7, literalDay: S.of(context).week),
        DayPair(intDay: 14, literalDay: S.of(context).week2),
        DayPair(intDay: 21, literalDay: S.of(context).week3),
        DayPair(intDay: 30, literalDay: S.of(context).month),
        DayPair(intDay: 60, literalDay: S.of(context).month2),
        DayPair(intDay: 90, literalDay: S.of(context).month3),
        DayPair(intDay: 180, literalDay: S.of(context).halfYear),
        DayPair(intDay: -1, literalDay: S.of(context).never),
      ];
}
