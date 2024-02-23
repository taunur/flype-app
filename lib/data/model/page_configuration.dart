class PageConfiguration {
  final bool unknown;
  final bool register;
  final bool? loggedIn;
  final String? storyId;

  PageConfiguration.splash()
      : unknown = false,
        register = false,
        loggedIn = null,
        storyId = null;

  PageConfiguration.login()
      : unknown = false,
        register = false,
        loggedIn = false,
        storyId = null;

  PageConfiguration.register()
      : unknown = false,
        register = true,
        loggedIn = false,
        storyId = null;

  PageConfiguration.home()
      : unknown = false,
        register = false,
        loggedIn = true,
        storyId = null;

  PageConfiguration.detailQuote(String id)
      : unknown = false,
        register = false,
        loggedIn = true,
        storyId = id;

  PageConfiguration.unknown()
      : unknown = true,
        register = false,
        loggedIn = null,
        storyId = null;

  bool get isSplashPage => unknown == false && loggedIn == null;
  bool get isLoginPage => unknown == false && loggedIn == false;
  bool get isHomePage =>
      unknown == false && loggedIn == true && storyId == null;
  bool get isDetailPage =>
      unknown == false && loggedIn == true && storyId != null;
  bool get isRegisterPage => register == true;
  bool get isUnknownPage => unknown == true;
}
