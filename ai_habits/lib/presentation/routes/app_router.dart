import 'package:ai_habits/database/database.dart';
import 'package:ai_habits/presentation/pages/home/home_page.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  final AppDatabase? database;

  AppRouter({this.database});

  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  late final List<AutoRoute> routes = [
    AutoRoute(
      page: HomeRoute.page,
      initial: true,
      path: '/',
    ),
  ];
}
