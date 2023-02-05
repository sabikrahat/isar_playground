import '../../../../db/db.dart' show db;
import '../../model/setting_model.dart';
import '../config/app_config_db.dart' show appConfig;

void changeTheme(int index) => db.writeTxnSync(
    () => db.appConfigs.putSync(appConfig.copyWith(themeIndex: index)));
