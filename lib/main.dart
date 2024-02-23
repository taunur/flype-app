import 'package:flutter/material.dart';
import 'package:flype/common/app_color.dart';
import 'package:flype/data/db/auth_repository.dart';
import 'package:flype/data/provider/auth_provider.dart';
import 'package:flype/data/provider/datetime_provider.dart';
import 'package:flype/data/provider/detail_story_provider.dart';
import 'package:flype/data/provider/page_provider.dart';
import 'package:flype/data/provider/story_provider.dart';
// import 'package:flype/routes/route_information_parser.dart';
import 'package:flype/routes/router_delegate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting('id_ID', null);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const FlypeApp());
  });
}

class FlypeApp extends StatefulWidget {
  const FlypeApp({Key? key}) : super(key: key);

  @override
  State<FlypeApp> createState() => _FlypeAppState();
}

class _FlypeAppState extends State<FlypeApp> {
late MyRouterDelegate myRouterDelegate;

  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    authProvider = AuthProvider(authRepository);
    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageProvider()),
        ChangeNotifierProvider(create: (context) => StoryTimeProvider()),
        ChangeNotifierProvider(create: (context) => StoryProvider()),
        ChangeNotifierProvider(create: (context) => DetailStoryProvider()),
        ChangeNotifierProvider(create: (context) => authProvider), 
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.nunitoSansTextTheme(),
          scaffoldBackgroundColor: AppColor.black,
          primaryColor: AppColor.blue,
          colorScheme: const ColorScheme.dark(
            primary: AppColor.blue,
            secondary: AppColor.secondary,
          ),
        ),
        routerDelegate: myRouterDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}