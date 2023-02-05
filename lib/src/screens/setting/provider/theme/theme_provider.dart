import 'package:flutter_riverpod/flutter_riverpod.dart'
    show Provider, StreamProvider;
import 'package:isar_playground/src/screens/setting/model/setting_model.dart';

import '../../../../db/db.dart' show db;
import '../config/app_config_db.dart' show appConfig;

final appConfigStream =
    StreamProvider((ref) => db.appConfigs.watchObjectLazy(0));

final themeProvider = Provider((ref) {
  ref.watch(appConfigStream);
  return appConfig.theme;
});
