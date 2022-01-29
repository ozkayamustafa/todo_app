import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
 part 'task_model.g.dart';
@HiveType(typeId: 1)
class Task {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String taskName;
  @HiveField(2)
  final DateTime createAt;
  @HiveField(3)
  bool isCompleted;

  Task(
      {required this.id,
      required this.taskName,
      required this.createAt,
      required this.isCompleted});

  factory Task.create({required String name, required DateTime createAt}) {
    return Task(
        id: Uuid().v1(),
        taskName: name,
        createAt: createAt,
        isCompleted: false);
  }
}
