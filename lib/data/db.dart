import 'package:hive/hive.dart';

class ToDoDB {
  List toDoList = [];
  final _myBox = Hive.box('myBox');
  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  void updateDB() {
    _myBox.put("TODOLIST", toDoList);
  }
}
