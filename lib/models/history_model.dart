import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 1)
class History extends HiveObject {
  @HiveField(0)
  String type;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime timestamp;

  History({
    required this.type,
    required this.content,
    required this.timestamp,
  });
}