part of 'settings_bloc.dart';

@immutable
abstract class SettingsEvent {}

class SettingsSaveDaysEvent extends SettingsEvent {
  final int daysIndex;

  SettingsSaveDaysEvent({required this.daysIndex});

}
