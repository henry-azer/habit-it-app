import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'app.dart';
import 'core/constants/hive_box_keys.dart';
import 'core/di/injection.dart';
import 'core/services/migration/shared_prefs_to_hive_migrator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Hive must initialise before any source is constructed (sources hold
  //    `Hive.box(...)` references, which need the box opened).
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox(HiveBoxKeys.app),
    Hive.openBox(HiveBoxKeys.user),
    Hive.openBox(HiveBoxKeys.settings),
    Hive.openBox(HiveBoxKeys.habits),
    Hive.openBox(HiveBoxKeys.notes),
    Hive.openBox(HiveBoxKeys.notificationsMeta),
    Hive.openBox(HiveBoxKeys.magicMeta),
  ]);

  // 2. Timezone data — required for the notification scheduling work in
  //    SCH-002 / ENG-006. Initialised here so the singleton table is hot.
  tz.initializeTimeZones();

  // 3. DI graph (depends on open Hive boxes + SharedPreferences).
  await configureDependencies();

  // 4. One-shot SharedPreferences → Hive migration (FND-002). Idempotent.
  final migrator = getIt<SharedPrefsToHiveMigrator>();
  await migrator.runIfNeeded();

  runApp(const HabitItApp());
}
