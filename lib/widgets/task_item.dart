import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';

class TaskItem extends StatefulWidget {
  Task taksItem;
  TaskItem({Key? key, required this.taksItem}) : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController _taskItemController = TextEditingController();
  late LocalStoragaData _localStoragaData;
  @override
  void initState() {
    super.initState();
    _localStoragaData = getIt<LocalStoragaData>();
    
  }

  @override
  Widget build(BuildContext context) {
    _taskItemController.text = widget.taksItem.taskName;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4.0,
            )
          ]),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.taksItem.isCompleted = !widget.taksItem.isCompleted;
            _localStoragaData.update(task: widget.taksItem);
            setState(() {});
          },
          child: Container(
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
                color:
                    widget.taksItem.isCompleted ? Colors.green : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 0.8)),
          ),
        ),
        title: widget.taksItem.isCompleted
            ? Text(
                widget.taksItem.taskName.toString(),
                style: TextStyle(
                    decoration: TextDecoration.lineThrough, color: Colors.grey),
              )
            : TextField(
                minLines: 1,
                maxLines: null,
                textInputAction: TextInputAction.done,
                controller: _taskItemController,
                decoration: InputDecoration(border: InputBorder.none),
                onSubmitted: (yeniDeger)  {
                  widget.taksItem.taskName = yeniDeger;
                   _localStoragaData.update(task: widget.taksItem);
                },
              ),
        trailing: Text(
          DateFormat('hh:mm:a').format(widget.taksItem.createAt),
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ),
    );
  }
}
