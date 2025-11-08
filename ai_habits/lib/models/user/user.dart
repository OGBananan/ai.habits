import 'package:ai_habits/models/base-object/base_object.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User extends BaseObject {
  @HiveField(3)
  String email;

  @HiveField(4)
  String displayName;

  @HiveField(5)
  Map<String, dynamic> prefs;

  User({
    required super.id,
    required super.createdAt,
    required this.email,
    required this.displayName,
    required this.prefs,
    super.updatedAt,
  });
}
