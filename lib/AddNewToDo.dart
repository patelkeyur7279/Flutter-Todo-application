import 'package:flutter/material.dart';
import 'package:to_do_application/DB/DBProvider.dart';
import 'package:to_do_application/DB/ModelToDo.dart';
import 'package:to_do_application/DB/Tags.dart';

class AddNewToDo extends StatefulWidget {
  bool isEdit = false;
  ModelToDo mData;

  AddNewToDo(this.mData, this.isEdit);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddNewToDo> {
  var _textEditingController = TextEditingController();

  Color statusColor1, statusColor2, statusColor3;
  int currentStatus = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isEdit) {
      switch (widget.mData.status) {
        case 0:
          statusColor1 = Colors.lightBlue;
          statusColor2 = Colors.grey;
          statusColor3 = Colors.grey;
          break;
        case 1:
          statusColor1 = Colors.lightBlue;
          statusColor2 = Colors.orangeAccent;
          statusColor3 = Colors.grey;
          break;
        case 2:
          statusColor1 = Colors.lightBlue;
          statusColor2 = Colors.orangeAccent;
          statusColor3 = Colors.redAccent;
          break;
      }
      _textEditingController.text = widget.mData.task;
    } else {
      statusColor1 = Colors.lightBlue;
      statusColor2 = Colors.grey;
      statusColor3 = Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? "Update Task" : "Add New Task"),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                    hintText: "Type Here...", border: InputBorder.none),
                keyboardType: TextInputType.multiline,
                autofocus: true,
                maxLines: null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                child: Row(
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: null,
                      backgroundColor: statusColor1,
                      onPressed: () {
                        currentStatus = Tags.TODO_TASK;
                        setState(() {
                          statusColor1 = Colors.lightBlue;
                          statusColor2 = Colors.grey;
                          statusColor3 = Colors.grey;
                        });
                      },
                      child: Text("To Do"),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    FloatingActionButton(
                      heroTag: null,
                      backgroundColor: statusColor2,
                      onPressed: () {
                        currentStatus = Tags.DOING_TASK;
                        setState(() {
                          statusColor1 = Colors.lightBlue;
                          statusColor2 = Colors.orangeAccent;
                          statusColor3 = Colors.grey;
                        });
                      },
                      child: Text("Doing"),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    FloatingActionButton(
                      heroTag: null,
                      backgroundColor: statusColor3,
                      onPressed: () {
                        currentStatus = Tags.DONE_TASK;
                        setState(() {
                          statusColor1 = Colors.lightBlue;
                          statusColor2 = Colors.orangeAccent;
                          statusColor3 = Colors.redAccent;
                        });
                      },
                      child: Text("Done"),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_textEditingController.text.isEmpty) {
            var data = ModelToDo();
            data.task = _textEditingController.text;
            data.status = currentStatus;
            if (widget.isEdit) {
              data.id = widget.mData.id;
              DBProvider.db.updateToDoById(data);
            } else {
              DBProvider.db.addNewTask(data);
            }

            _textEditingController.dispose();
            FocusScope.of(context).requestFocus(FocusNode());
            Navigator.pop(context);
          }
        },
        child: Icon(Icons.done),
        tooltip: 'Done',
      ),
    );
  }
}
