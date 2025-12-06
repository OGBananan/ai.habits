import 'package:ai_habits/database/database.dart';
import 'package:ai_habits/presentation/app.dart';
import 'package:flutter/widgets.dart';

/// Application configuration passed from main.dart to bootstrap
class AppConfig {
  final String environment;
  final String appTitle;
  final bool enableDebugLogging;
  final bool enableAnalytics;
  final Map<String, dynamic>? additionalConfig;

  const AppConfig({
    required this.environment,
    required this.appTitle,
    this.enableDebugLogging = false,
    this.enableAnalytics = false,
    this.additionalConfig,
  });
}

/// Bootstrap class for initializing application dependencies
class Bootstrap {
  /// Initializes the database and other required services
  /// Returns the initialized database or null if initialization failed
  static Future<AppDatabase?> initializeDatabase(AppConfig config) async {
    AppDatabase? database;
    try {
      if (config.enableDebugLogging) {
        print('[${config.environment}] Initializing database...');
      }
      database = AppDatabase();
      if (config.enableDebugLogging) {
        print('[${config.environment}] Database initialized successfully');
        debugPrint('[${config.environment}] Database initialized successfully');
      }

      // Test database connection
      if (config.enableDebugLogging) {
        print('[${config.environment}] Testing database connection...');
      }
      final testQuery = await database.select(database.users).get();
      if (config.enableDebugLogging) {
        print('[${config.environment}] Database test query successful, found ${testQuery.length} users');
      }
    } catch (e, stackTrace) {
      print('[${config.environment}] Error initializing database: $e');
      print('[${config.environment}] Stack trace: $stackTrace');
      debugPrint('[${config.environment}] Error initializing database: $e');
      debugPrint('[${config.environment}] Stack trace: $stackTrace');
    }
    return database;
  }

  /// Initializes all application services based on the provided configuration
  /// This method can be extended to initialize other services like:
  /// - Analytics (based on config.enableAnalytics)
  /// - Crash reporting
  /// - Remote configuration
  /// - Authentication
  /// etc.
  ///
  /// Returns the initialized App widget ready to be run
  static Future<App> initialize(AppConfig config) async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize database
    final database = await initializeDatabase(config);

    // Here you can add other initialization logic based on config:
    // - if (config.enableAnalytics) { initializeAnalytics(); }
    // - initializeCrashReporting();
    // - initializeRemoteConfig();
    // etc.

    // Initialize and return the App widget
    return App(database: database, config: config);
  }
}
