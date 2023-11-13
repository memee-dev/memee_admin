import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/landing/landing_page.dart';
import '../../ui/login/login_page.dart';
import '../../ui/splash/splash_page.dart';




final GoRouter appRouter = GoRouter(
  navigatorKey: GlobalKey<NavigatorState>(),
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, state) => const SplashPage(),
      routes: [
        GoRoute(
          path: 'login',
          builder: (_, state) => LoginPage(),
        ),
        GoRoute(
          path: 'landing',
          builder: (_, state) => const LandingPage(),
        ),
      ],
    ),
  ],
);
