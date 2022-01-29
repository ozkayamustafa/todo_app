import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/helper/translation_helper.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/search_delegate.dart';
import 'package:todo_app/widgets/task_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Task> _allTasks;
  late LocalStoragaData _localStoragaData;
  @override
  void initState() {
    super.initState();
    _localStoragaData = getIt<LocalStoragaData>();
    _allTasks = <Task>[];
    _getAllTaskDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            _showAddTaskBottomSheet(context);
          },
          child: Text(
            "title",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                _showSearchPage();
              },
              icon: Icon(Icons.search)),
          IconButton(
              onPressed: () {
                _showAddTaskBottomSheet(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: _allTasks.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                var onankiListe = _allTasks[index];
                return Dismissible(
                  background: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.delete), Text("remove_task").tr()],
                  ),
                  key: Key(onankiListe.id),
                  onDismissed: (direction) {
                    _allTasks.removeAt(index);
                    _localStoragaData.delete(task: onankiListe);
                    setState(() {});
                  },
                  child: TaskItem(
                    taksItem: onankiListe,
                  ),
                );
              },
              itemCount: _allTasks.length,
            )
          : Center(
              child: Text("empty_task_list").tr(),
            ),
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ListTile(
              title: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: "add_task".tr(), border: InputBorder.none),
                onSubmitted: (value) {
                  Navigator.of(context).pop();
                  DatePicker.showTimePicker(
                    context,
                    locale: TranslationHelper.getDeviceLanguages(context),
                    showSecondsColumn: false,
                    onConfirm: (time) async {
                      var yeniEklenecekGorev =
                          Task.create(name: value, createAt: time);
                      _allTasks.insert(0, yeniEklenecekGorev);
                      await _localStoragaData.insert(task: yeniEklenecekGorev);
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  void _getAllTaskDb() async {
    _allTasks = await _localStoragaData.getAllTask();
    setState(() {});
  }

  Future<void> _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTasks));
    _getAllTaskDb();
  }
}
