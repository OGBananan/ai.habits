import 'package:ai_habits/models/journal/journal.dart';
import 'package:ai_habits/models/user/user.dart';
import 'package:hive_ce/hive.dart';

@GenerateAdapters(
  [
    AdapterSpec<Journal>(),
    AdapterSpec<User>(),
  ],
  firstTypeId: 1,
)
part 'hive_adapters.g.dart';

class HiveAdapters {
  static void register() {
    Hive.registerAdapter(JournalAdapter());
    Hive.registerAdapter(UserAdapter());
  }
}
