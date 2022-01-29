import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/models/task_model.dart';

class HiveLocalStoraga implements LocalStoragaData {
  late Box<Task> _taskBox;

  HiveLocalStoraga() {
    _taskBox = Hive.box<Task>("Tasks");
  }

  @override
  Future<void> delete({required Task task}) async {
    await _taskBox.delete(task.id);
  }

  @override
  Future<List<Task>> getAllTask() async {
    List<Task> _allTask = <Task>[];
    _allTask = _taskBox.values.toList();
    if (_allTask.length > 0) {
      _allTask.sort((Task a, Task b) => b.createAt.compareTo(a.createAt));
    }
    return _allTask;
  }

  @override
  Future<Task?> getSelect({required String taskId}) async {
    Task? task = _taskBox.get(taskId);
    return task;
  }

  @override
  Future<void> insert({required Task task}) async {
    await _taskBox.put(task.id, task);
  }

  @override
  Future<void> update({required Task task}) async {
    await _taskBox.put(task.id, task);
  }
}
