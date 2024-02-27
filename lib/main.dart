import 'package:flutter/material.dart';
import 'package:flype/common/export.dart';
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
import 'package:flype/data/theme/dark_theme.dart';
import 'package:flype/data/theme/light_theme.dart';
import 'package:flype/data/utils/app_constants.dart';
import 'package:flype/routes/config_go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  initializeDateFormatting('id_ID', null);

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

class FlypeApp extends StatelessWidget {
  const FlypeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocalizationProvider>(context);

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: provider.locale,
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).darkTheme
          ? darkTheme
          : lightTheme,
      routerConfig: goRouter,
    );
  }
}
