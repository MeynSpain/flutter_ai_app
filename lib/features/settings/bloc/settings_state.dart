part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final List<DayPair> daysList;
  final int selectedDaysIndex;

  const SettingsState._({required this.daysList, required this.selectedDaysIndex});

  SettingsState copyWith({
    List<DayPair>? daysList,
    int? selectedDaysIndex,
  }) {
    return SettingsState._(
      daysList: daysList ?? this.daysList,
      selectedDaysIndex: selectedDaysIndex ?? this.selectedDaysIndex,
    );
  }

  factory SettingsState.initial() {
    int? daysFromPrefs = getIt<PrefsUtils>().getDays();
    int index = daysSettingsList.indexWhere((element) => (daysFromPrefs ?? 14) == element.intDay);
    return SettingsState._(
      daysList: daysSettingsList,
      selectedDaysIndex: (index != -1) ? index : 2,
    );
  }

  @override
  List<Object?> get props => [daysList, selectedDaysIndex];
}
