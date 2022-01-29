import 'package:todo_app/models/task_model.dart';

abstract class LocalStoragaData {
  Future<void> insert({required Task task});
  Future<Task?> getSelect({required String taskId});
  Future<List<Task>> getAllTask();
  Future<void> delete({required Task task});
  Future<void> update({required Task task});
}
