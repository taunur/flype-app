import 'package:flutter/material.dart';
import 'package:flype/data/model/page_configuration.dart';
import 'package:flype/pages/get_started_page.dart';
import 'package:flype/pages/login_page.dart';
import 'package:flype/pages/unknown_page.dart';

/// todo 8: add T class to router delegate to maintaining the page configuration
class MyRouterDelegate extends RouterDelegate<PageConfiguration>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;

  /// todo 11: add variable to detect unknown page
  bool? isUnknown;

  MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedQuote;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    /// todo 12: adding new conditional statement for unknown
    if (isUnknown == true) {
      historyStack = _unknownStack;
    } else if (isLoggedIn == null) {
      historyStack = _getStartedStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isRegister = false;
        selectedQuote = null;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  PageConfiguration? get currentConfiguration {
    if (isLoggedIn == null) {
      return PageConfiguration.getStarted();
    } else if (isRegister == true) {
      return PageConfiguration.register();
    } else if (isLoggedIn == false) {
      return PageConfiguration.login();
    } else if (isUnknown == true) {
      return PageConfiguration.unknown();
    } else if (selectedQuote == null) {
      return PageConfiguration.home();
    } else if (selectedQuote != null) {
      return PageConfiguration.detailQuote(selectedQuote!);
    } else {
      return null;
    }
  }

  /// todo 10: set a new route
  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) async {
    if (configuration.isUnknownPage) {
      isUnknown = true;
      isRegister = false;
    } else if (configuration.isRegisterPage) {
      isRegister = true;
    } else if (configuration.isHomePage ||
        configuration.isLoginPage ||
        configuration.isGetStartedPage) {
      isUnknown = false;
      selectedQuote = null;
      isRegister = false;
    } else if (configuration.isDetailPage) {
      isUnknown = false;
      isRegister = false;
      selectedQuote = configuration.quoteId.toString();
    } else {
      debugPrint(' Could not set new route');
    }

    notifyListeners();
  }

  List<Page> get _unknownStack => const [
        MaterialPage(
          key: ValueKey("UnknownPage"),
          child: UnknownScreen(),
        ),
      ];

  List<Page> get _getStartedStack => const [
        MaterialPage(
          key: ValueKey("SplashScreen"),
          child: GetStartedPage(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginPage(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
      ];

  // List<Page> get _loggedInStack => [
  //       MaterialPage(
  //         key: const ValueKey("QuotesListPage"),
  //         child: QuotesListScreen(
  //           quotes: quotes,
  //           onTapped: (String quoteId) {
  //             selectedQuote = quoteId;
  //             notifyListeners();
  //           },
  //           onLogout: () {
  //             isLoggedIn = false;
  //             notifyListeners();
  //           },
  //         ),
  //       ),
  //       if (selectedQuote != null)
  //         MaterialPage(
  //           key: ValueKey(selectedQuote),
  //           child: QuoteDetailsScreen(
  //             quoteId: selectedQuote!,
  //           ),
  //         ),
  //     ];
}
