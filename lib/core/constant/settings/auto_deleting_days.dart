class DayPair {
  final int intDay;
  final String literalDay;

  DayPair({required this.intDay, required this.literalDay});

}

List<DayPair> daysSettingsList = [
  DayPair(intDay: 1, literalDay: 'День'),
  DayPair(intDay: 7, literalDay: 'Неделя'),
  DayPair(intDay: 14, literalDay: '2 Недели'),
  DayPair(intDay: 21, literalDay: '3 Недели'),
  DayPair(intDay: 30, literalDay: 'Месяц'),
  DayPair(intDay: 60, literalDay: '2 Месяца'),
  DayPair(intDay: 90, literalDay: '3 Месяца'),
  DayPair(intDay: 180, literalDay: 'Пол года'),
  DayPair(intDay: -1, literalDay: 'Никогда')
];
