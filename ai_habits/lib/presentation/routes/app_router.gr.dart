// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    Key? key,
    required AppDatabase database,
    List<PageRouteInfo>? children,
  }) : super(
         HomeRoute.name,
         args: HomeRouteArgs(key: key, database: database),
         initialChildren: children,
       );

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<HomeRouteArgs>();
      return HomePage(key: args.key, database: args.database);
    },
  );
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key, required this.database});

  final Key? key;

  final AppDatabase database;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, database: $database}';
  }
}
