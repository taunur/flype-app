import 'package:flutter/material.dart';
import 'package:flype/common/export.dart';
import 'package:flype/data/provider/auth_provider.dart';
import 'package:flype/data/provider/theme_provider.dart';
import 'package:flype/routes/config_go_router.dart';
import 'package:flype/widgets/flag_icon_widget.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.setings,
        ),
        centerTitle: true,
      ),
      body: _buildList(context),
    );
  }
}

Widget _buildList(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final authWatch = context.watch<AuthProvider>();

  /// Theme toggle
  return ListView(
    children: [
      Material(
        child: ListTile(
          title: themeProvider.darkTheme
              ? Text(AppLocalizations.of(context)!.darkTheme)
              : Text(AppLocalizations.of(context)!.lightTheme),
          trailing: Switch.adaptive(
            value: themeProvider.darkTheme,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
        ),
      ),
      Material(
        child: ListTile(
          title: Text(AppLocalizations.of(context)!.changeLanguage),
          trailing: const FlagIconWidget(),
        ),
      ),
      Material(
        child: ListTile(
          title: Text(AppLocalizations.of(context)!.logout),
          trailing: TextButton(
            onPressed: () async {
              final authRead = context.read<AuthProvider>();
              final result = await authRead.logout();
              if (result) {
                goRouter.replace('/');
              }
            },
            child: authWatch.isLoadingLogout
                ? const CircularProgressIndicator()
                : Transform.rotate(
                    angle: math.pi,
                    child: const Icon(
                      Icons.logout,
                    ),
                  ),
          ),
        ),
      ),
    ],
  );
}
