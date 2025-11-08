import 'package:ai_habits/models/base-object/base_object.dart';
import 'package:hive/hive.dart';

part 'journal.g.dart';

@HiveType(typeId: 2)
class Journal extends BaseObject {
  @HiveField(3)
  String type;

  @HiveField(4)
  String content;

  @HiveField(5)
  Map<String, dynamic> properties;

  Journal({
    required super.id,
    required super.createdAt,
    required this.type,
    required this.content,
    super.updatedAt,
    required this.properties,
  });
}
