import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit_it/app.dart';
import 'package:habit_it/config/localization/app_localization.dart';
import 'package:habit_it/config/supabase/supabase_config.dart';
import 'package:habit_it/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLocalization.initialize();
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  await di.init();

  runApp(const HabitItApp());
}
