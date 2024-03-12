import 'package:flutter/material.dart';
import 'package:flype/common/export.dart';
import 'package:flype/config/flavor_config.dart';
import 'package:flype/data/provider/localizations_provider.dart';
import 'package:flype/data/provider/theme_provider.dart';
import 'package:flype/data/theme/dark_theme.dart';
import 'package:flype/data/theme/light_theme.dart';
import 'package:flype/routes/config_go_router.dart';
import 'package:provider/provider.dart';

class FlypeApp extends StatelessWidget {
  const FlypeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocalizationProvider>(context);

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: provider.locale,
      title: FlavorConfig.instance.values.titleApp,
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).darkTheme
          ? darkTheme
          : lightTheme,
      routerConfig: goRouter,
    );
  }
}
