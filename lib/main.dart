
import 'package:flutter/material.dart' show runApp;
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;

import 'src/app.dart' show App;
import 'src/db/db.dart' show openAppDB;
import 'src/utils/paths/paths.dart' show initDir;

void main() async {
  await initDir();
  await openAppDB();
  runApp(const ProviderScope(child: App()));
}
