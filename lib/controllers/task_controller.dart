import 'package:get/get.dart';
import 'package:todo_app_flutter/db/db_helper.dart';
import 'package:todo_app_flutter/models/task.dart';

class TaskController extends GetxController{
  @override
  void onReady(){
     super.onReady();
  }
  var taskList=<Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DBHelper.insert(task);
  }
  void getTask() async{
    List<Map<String,dynamic>> tasks=await DBHelper.query();
    taskList.assignAll(tasks.map((data)=>new Task.fromJson(data)).toList());
  }
  void delete(Task task){
      var val=DBHelper.delete(task);
      getTask();
  }
  void markTaskCompleted(int id)async{
    await DBHelper.update(id);
    getTask();
  }
}