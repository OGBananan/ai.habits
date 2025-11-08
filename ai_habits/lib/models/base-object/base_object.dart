import 'package:hive_ce/hive.dart';

part 'base_object.g.dart';

@HiveType(typeId: 0)
class BaseObject extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime createdAt;

  @HiveField(2)
  DateTime? updatedAt;

  BaseObject({
    required this.id,
    required this.createdAt,
    this.updatedAt,
  });
}
