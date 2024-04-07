import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/Presentation/widgets/dialog_box.dart';
import 'package:todo/Presentation/widgets/todo_tile.dart';
import 'package:todo/data/db.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});
  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final _myBox = Hive.box('myBox');
  ToDoDB db = ToDoDB();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_myBox.get("TODOLIST") != null) {
      db.loadData();
    }
  }

  final _controller = TextEditingController();

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDB();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.pop(context);
    db.updateDB();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onCancel: () => Navigator.pop(context),
          onSaved: saveNewTask,
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("To Do"),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (db.toDoList.isEmpty) {
      return Center(
        child: Text(
          "Add a Task",
        ),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) => ToDoTile(
            deleteFunction: (context) => deleteTask(index),
            taskName: db.toDoList[index][0],
            taskCompleted: db.toDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index)),
        itemCount: db.toDoList.length,
      );
    }
  }
}
