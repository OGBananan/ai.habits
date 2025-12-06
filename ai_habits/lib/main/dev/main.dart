import 'package:ai_habits/main/bootstrap.dart';
import 'package:flutter/material.dart';

void main() async {
  // Pass dev environment configuration to bootstrap
  const config = AppConfig(
    environment: 'dev',
    appTitle: 'AI Habits - Dev',
    enableDebugLogging: true,
    enableAnalytics: false,
  );

  // Bootstrap initializes everything and returns the App widget
  final app = await Bootstrap.initialize(config);
  runApp(app);
}
