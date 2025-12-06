import 'package:ai_habits/main/bootstrap.dart';
import 'package:flutter/material.dart';

void main() async {
  // Pass UAT environment configuration to bootstrap
  const config = AppConfig(
    environment: 'uat',
    appTitle: 'AI Habits - UAT',
    enableDebugLogging: true,
    enableAnalytics: true,
  );
  
  // Bootstrap initializes everything and returns the App widget
  final app = await Bootstrap.initialize(config);
  runApp(app);
}

