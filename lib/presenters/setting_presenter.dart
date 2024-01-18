
import 'package:sales_application/presenters/setting.dart';

import '../model/info_reader.dart';

class SettingPresenter {
  static Setting setting = Setting();

  static Future<void> changeThemeMode() async {
    setting.themeModeLight = !setting.themeModeLight;
    await InfoReader().saveSetting();
  }

  static Future<void> changeLanguage() async {
    setting.changeLanguage();
    await InfoReader().saveSetting();
  }
}
