import 'package:ai_habits/database/database.dart';
import 'package:ai_habits/main/bootstrap.dart';
import 'package:ai_habits/presentation/routes/app_router.dart';
import 'package:flutter/material.dart';

/// Central MaterialApp widget initialized by bootstrap
class App extends StatefulWidget {
  final AppDatabase? database;
  final AppConfig config;

  const App({
    super.key,
    required this.database,
    required this.config,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  /// Gets the theme color based on environment
  Color _getThemeColor() {
    switch (widget.config.environment) {
      case 'dev':
        return Colors.deepPurple;
      case 'uat':
        return Colors.orange;
      case 'prod':
        return Colors.blue;
      default:
        return Colors.deepPurple;
    }
  }

  late final appRouter = AppRouter(database: widget.database);

  @override
  Widget build(BuildContext context) {
    // Show error screen if database initialization failed
    if (widget.database == null) {
      return MaterialApp(
        title: widget.config.appTitle,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Database initialization failed',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Please check the console for details'),
              ],
            ),
          ),
        ),
      );
    }

    // Main app with MaterialApp.router using router delegate
    return MaterialApp.router(
      title: widget.config.appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _getThemeColor()),
        useMaterial3: true,
      ),
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(includePrefixMatches: true),
    );
  }
}
