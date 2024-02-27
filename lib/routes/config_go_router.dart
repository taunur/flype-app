import 'package:flutter/material.dart';
import 'package:flype/data/db/auth_repository.dart';
import 'package:flype/pages/add_story_page.dart';
import 'package:flype/pages/detail_page.dart';
import 'package:flype/pages/get_started_page.dart';
import 'package:flype/pages/login_page.dart';
import 'package:flype/pages/register_page.dart';
import 'package:flype/pages/splash_page.dart';
import 'package:flype/widgets/navbar.dart';
import 'package:go_router/go_router.dart';

final GoRouter goRouter = GoRouter(
  initialLocation: '/splashPage',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const GetStartedPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterPage();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/splashPage',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashPage();
      },
      redirect: (BuildContext context, GoRouterState state) async {
        final authRepository = AuthRepository();
        final loggedIn = await authRepository.isLoggedIn();
        if (loggedIn) {
          // Redirect ke halaman Navbar jika sudah login
          return '/navBar';
        } else {
          return null;
        }
      },
    ),
    GoRoute(
      path: '/navBar',
      builder: (BuildContext context, GoRouterState state) {
        return const Navbar();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'addStory',
          builder: (BuildContext context, GoRouterState state) {
            return const AddStoryPage();
          },
        ),
        GoRoute(
          path: 'stories/:id',
          builder: (BuildContext context, GoRouterState state) {
            final storyId = state.pathParameters['id'];
            return DetailPage(storyId: storyId ?? '');
          },
        ),
      ],
    ),
  ],
);
