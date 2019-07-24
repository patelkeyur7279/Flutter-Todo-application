import 'package:flutter/material.dart';
import 'package:to_do_application/AddNewToDo.dart';
import 'package:to_do_application/DB/DBProvider.dart';
import 'package:to_do_application/DB/ModelToDo.dart';
import 'package:to_do_application/DB/Tags.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'To Do List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder<List<ModelToDo>>(
          future: DBProvider.db.getAllToDoListData(),
          builder: (context, AsyncSnapshot<List<ModelToDo>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  ModelToDo data = snapshot.data[index];
                  return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.red,
                      ),
                      onDismissed: (direction) {
                        DBProvider.db.deleteToDo(data);
                      },
                      child: ListTile(data));
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewToDo(null, false)));
        },
        tooltip: 'Add New Task',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ListTile extends StatelessWidget {
  ModelToDo data;

  ListTile(this.data);

  @override
  Widget build(BuildContext context) {
    String status = "";
    Color statusColor;
    switch (data.status) {
      case 0:
        status = "To Do";
        statusColor = Colors.lightBlue;
        break;
      case 1:
        status = "Doing";
        statusColor = Colors.orangeAccent;
        break;
      case 2:
        status = "Done";
        statusColor = Colors.redAccent;
        break;
    }
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddNewToDo(data, true)));
      },
      child: Card(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(color: statusColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(status, textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data.task),
          ),
        ],
      )),
    );
  }
}
