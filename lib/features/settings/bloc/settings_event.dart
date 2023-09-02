part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class SettingsAutoDeleteInitial extends SettingsEvent {
  final BuildContext context;

  SettingsAutoDeleteInitial({required this.context});
}

class SettingsSaveDaysEvent extends SettingsEvent {
  final int daysIndex;

  SettingsSaveDaysEvent({required this.daysIndex});
}
