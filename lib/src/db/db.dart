import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:isar/isar.dart' show Isar;
import 'package:isar_playground/src/models/model.dart';

import '../screens/setting/model/setting_model.dart';
import '../utils/paths/paths.dart' show appDBDir;

late final Isar db;

Future<void> openAppDB() async => db = await Isar.open(
      [AppConfigSchema, TeacherSchema, StudentSchema, DepartmentSchema],
      directory: appDBDir.path,
      inspector: !kReleaseMode,
    );
