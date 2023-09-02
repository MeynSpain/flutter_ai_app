import 'package:flutter_ai/core/constant/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsUtils {
  final SharedPreferences prefs;

  PrefsUtils({
    required this.prefs,
  });

  Future<void> saveDays(int days) async {
    await prefs.setInt(PrefsNames.expirationDate, days);
  }

  int? getDays() => prefs.getInt(PrefsNames.expirationDate);

  Future<void> saveSubcribe(bool isSubscribe) async {
    await prefs.setBool(PrefsNames.isSubscribe, isSubscribe);
  }

  bool getSubscribe() {
    bool? isSub = prefs.getBool(PrefsNames.isSubscribe);
    if (isSub == null) {
      saveSubcribe(false);
      return false;
    }
    return isSub;
  }
}
