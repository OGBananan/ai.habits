import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  // Schema validation is disabled for now.
  // To enable it, run `dart run drift_dev make-migrations` to generate
  // the necessary migration files, then use VerifySelf from drift_dev.
  // For details, see: https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime
  if (kDebugMode) {
    debugPrint('Database schema validation skipped (no migration files yet)');
  }
}
