import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/helper/translation_helper.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/viewmodel/color_viewmodel.dart';
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
  late ColorViewModel _colorProvider;
  @override
  void initState() {
    super.initState();
    _localStoragaData = getIt<LocalStoragaData>();
    _allTasks = <Task>[];
    _getAllTaskDb();
  }

  @override
  Widget build(BuildContext context) {
    _colorProvider = Provider.of<ColorViewModel>(context);
    return Scaffold(
      backgroundColor: _colorProvider.getIsGreen
          ? Color.fromRGBO(53, 124, 60, 1.0)
          : _colorProvider.getIsPurple
              ? Color.fromRGBO(87, 51, 145, 1.0)
              : _colorProvider.getIsRed
                  ? Color.fromRGBO(239, 109, 109, 1.0)
                  : _colorProvider.getIsYellow
                      ? Color.fromRGBO(255, 230, 171, 1.0)
                      : Colors.white,
      appBar: AppBar(
        backgroundColor: _colorProvider.getIsGreen
            ? Color.fromRGBO(53, 124, 60, 1.0)
            : _colorProvider.getIsPurple
                ? Color.fromRGBO(87, 51, 145, 1.0)
                : _colorProvider.getIsRed
                    ? Color.fromRGBO(239, 109, 109, 1.0)
                    : _colorProvider.getIsYellow
                        ? Color.fromRGBO(255, 230, 171, 1.0)
                        : Colors.white,
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
                _showDialogBottom(context);
              },
              icon: Icon(Icons.color_lens)),
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

  void _showDialogBottom(BuildContext context) {
    var myModel = Provider.of<ColorViewModel>(context,listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ListenableProvider.value(
                    value: myModel,
                    child: purpleIsCheck(),
                  ),
                  ListenableProvider.value(
                    value: myModel,
                    child: greenIsCheck(),
                  ),
                  ListenableProvider.value(
                    value: myModel,
                    child: redIsCheck(),
                  ),
                  ListenableProvider.value(
                    value: myModel,
                    child: yellowIsCheck(),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget purpleIsCheck() {
    return InkWell(
      onTap: () {
        _colorProvider.setIsYellow = false;
        _colorProvider.setIsRed = false;
        _colorProvider.setIsPurple = !_colorProvider.getIsPurple;
        _colorProvider.setIsGreen = false;

        debugPrint(_colorProvider.getIsPurple.toString());
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(87, 51, 145, 1.0),
        ),
        child: Visibility(
            visible: context.watch<ColorViewModel>().getIsPurple,
            child: Center(
              child: Icon(
                Icons.check,
                size: 36,
                color: Colors.white,
              ),
            )),
      ),
    );
  }

  Widget greenIsCheck() {
    return InkWell(
      onTap: () {
        _colorProvider.setIsYellow = false;
        _colorProvider.setIsRed = false;
        _colorProvider.setIsPurple = false;
        _colorProvider.setIsGreen = !_colorProvider.getIsGreen;
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(53, 124, 60, 1.0),
        ),
        child: Visibility(
            visible: context.watch<ColorViewModel>().getIsGreen,
            child: Center(
              child: Icon(
                Icons.check,
                size: 36,
                color: Colors.white,
              ),
            )),
      ),
    );
  }

  Widget redIsCheck() {
    return InkWell(
      onTap: () {
        _colorProvider.setIsYellow = false;
        _colorProvider.setIsRed = !_colorProvider.getIsRed;
        _colorProvider.setIsPurple = false;
        _colorProvider.setIsGreen = false;
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(239, 109, 109, 1.0),
        ),
        child: Visibility(
            visible: context.watch<ColorViewModel>().getIsRed,
            child: Center(
              child: Icon(
                Icons.check,
                size: 36,
                color: Colors.white,
              ),
            )),
      ),
    );
  }

  Widget yellowIsCheck() {
    return InkWell(
      onTap: () {
        _colorProvider.setIsYellow = !_colorProvider.getIsYellow;
        _colorProvider.setIsRed = false;
        _colorProvider.setIsPurple = false;
        _colorProvider.setIsGreen = false;
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(255, 230, 171, 1.0),
        ),
        child: Visibility(
            visible: context.watch<ColorViewModel>().getIsYellow,
            child: Center(
              child: Icon(
                Icons.check,
                size: 36,
                color: Colors.white,
              ),
            )),
      ),
    );
  }
}
