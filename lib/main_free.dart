import 'package:flutter/material.dart';
import 'package:flype/config/flavor_config.dart';
import 'package:flype/data/api/add_story_service.dart';
import 'package:flype/data/db/auth_repository.dart';
import 'package:flype/data/provider/add_story_provider.dart';
import 'package:flype/data/provider/auth_provider.dart';
import 'package:flype/data/provider/datetime_provider.dart';
import 'package:flype/data/provider/detail_story_provider.dart';
import 'package:flype/data/provider/localizations_provider.dart';
import 'package:flype/data/provider/page_provider.dart';
import 'package:flype/data/provider/story_provider.dart';
import 'package:flype/data/provider/theme_provider.dart';
import 'package:flype/data/provider/upload_provider.dart';
import 'package:flype/flype_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  initializeDateFormatting('id_ID', null);

  FlavorConfig(
    flavor: FlavorType.free,
    values: const FlavorValues(
      titleApp: "FLYPE Free",
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPreferences>.value(value: sharedPreferences),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            AuthRepository(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ThemeProvider(sharedPreferences: sharedPreferences),
        ),
        ChangeNotifierProvider(create: (context) => PageProvider()),
        ChangeNotifierProvider(create: (context) => StoryTimeProvider()),
        ChangeNotifierProvider(create: (context) => StoryProvider()),
        ChangeNotifierProvider(create: (context) => DetailStoryProvider()),
        ChangeNotifierProvider(create: (context) => AddStoryProvider()),
        ChangeNotifierProvider(
          create: (context) => UploadProvider(
            AddStoryService(),
            AuthRepository(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => LocalizationProvider()),
      ],
      child: const FlypeApp(),
    ),
  );
}
