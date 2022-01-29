import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/task_item.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  CustomSearchDelegate({
    required this.allTask,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = "";
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
      onTap: () {
        close(context, null);
      },
      child: Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var filterTask = allTask
        .where((element) =>
            element.taskName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filterTask.isNotEmpty
        ? ListView.builder(
            itemBuilder: (context, index) {
              var onankiListe = filterTask[index];
              return Dismissible(
                background: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.delete), Text("remove_task").tr()],
                ),
                key: Key(onankiListe.id),
                onDismissed: (direction) async {
                  filterTask.removeAt(index);
                  await getIt<LocalStoragaData>().delete(task: onankiListe);
                },
                child: TaskItem(
                  taksItem: onankiListe,
                ),
              );
            },
            itemCount: filterTask.length,
          )
        : Center(
            child: Text("search_not_find").tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
