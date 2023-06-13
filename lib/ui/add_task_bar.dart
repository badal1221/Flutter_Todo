import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/controllers/task_controller.dart';
import 'package:todo_app_flutter/models/task.dart';
import 'package:todo_app_flutter/ui/theme.dart';
import 'package:todo_app_flutter/ui/widgets/button.dart';
import 'package:todo_app_flutter/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget{
  const AddTaskPage({Key?key}):super(key:key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController=Get.put(TaskController());
  final TextEditingController _titleController=TextEditingController();
  final TextEditingController _noteController=TextEditingController();
  DateTime _selectedDate=DateTime.now();
  String _startTime=DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime="9:30 PM";
  int _selectedRemind=5;
  List<int> remindList=[5,10,15,20,25,30];
  String _selectedRepeat="None";
  List<String> repeatList=["None","Daily","Weekly","Monthly"];
  int _selectedColor=0;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20,),
         child: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
                 Text("Add text",style: HeadingStyle,),
               MyInputField(title: "Title", hint:"Enter your title",controller: _titleController,),
               MyInputField(title: "Note", hint:"Enter your Note",controller: _noteController,),
               MyInputField(title: "Date", hint:DateFormat.yMMMMd().format(_selectedDate),
               widget: IconButton(
                 icon:Icon(Icons.calendar_today_outlined,
                 color: Colors.grey,),
                 onPressed: (){
                   _getDateFromUser();
                 },
               ),),
               Row(children: [
                 Expanded(
                     child:MyInputField(title:"Start Time",hint:_startTime,
                     widget: IconButton(
                       onPressed: (){
                         _getTimeFromUser(isStartTime: true);
                       },
                       icon: Icon(Icons.access_time_rounded,
                       color: Colors.grey,),
                     ),)
                 ),
                 SizedBox(width: 12,),
                 Expanded(
                     child:MyInputField(title:"End Time",hint:_endTime,
                       widget: IconButton(
                         onPressed: (){
                           _getTimeFromUser(isStartTime:false);
                         },
                         icon: Icon(Icons.access_time_rounded,
                           color: Colors.grey,),
                       ),)
                 ),
               ],),
               MyInputField(title: "Remind", hint:"$_selectedRemind minutes early",
               widget: DropdownButton(
                 icon: Icon(Icons.keyboard_arrow_down,
                 color: Colors.grey,),
                 iconSize: 24,
                 elevation: 4,
                 style: subTitleStyle,
                 underline: Container(height: 0,),
                 items: remindList.map<DropdownMenuItem<String>>((int value){
                   return DropdownMenuItem<String>(
                     value: value.toString(),
                     child: Text(value.toString(),style: TextStyle(color: Colors.grey),)
                   );
                 }).toList(),
                 onChanged: (String? value) {
                   setState(() {
                     _selectedRemind=int.parse(value!);
                   });
                 },
               ),),
               MyInputField(title: "Repeat", hint:"$_selectedRepeat",
                 widget: DropdownButton(
                   icon: Icon(Icons.keyboard_arrow_down,
                     color: Colors.grey,),
                   iconSize: 24,
                   elevation: 4,
                   style: subTitleStyle,
                   underline: Container(height: 0,),
                   items: repeatList.map<DropdownMenuItem<String>>((String value){
                     return DropdownMenuItem<String>(
                       value: value,
                       child: Text(value,style: TextStyle(color: Colors.grey),),
                     );
                   }).toList(),
                   onChanged: (String? value) {
                     setState(() {
                       _selectedRepeat=value!;
                     });
                   },
                 ),),
               SizedBox(height: 18,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   _colorPallete(),
                   MyButton(label: "Create Task", onTap: ()=>_validateDate()),
                 ],
               ),
             ],
           ),
         ),
      ),
    );
  }
  _validateDate(){
    if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
      _addTaskToDb();
      Get.back();
    }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
      Get.snackbar("Required","All fields are required !" ,
          snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: pinkClr,
      icon: Icon(Icons.warning_amber_rounded,
      color: Colors.red[900],));
    }
  }
  _addTaskToDb() async{
    int value= await _taskController.addTask(
        task:Task(note:_noteController.text,
        title:_titleController.text,
        isCompleted:0,
        date:DateFormat.yMd().format(_selectedDate),
        startTime:_startTime,
        endTime:_endTime,
        color:_selectedColor,
        remind:_selectedRemind,
        repeat:_selectedRepeat));
    print("Last inserted row's id is $value");
  }
  _colorPallete(){
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
        Text("Color",style: titleStyle,),
        SizedBox(height: 8.0,),
        Wrap(
          children:List<Widget>.generate(
              3, (int index){
            return GestureDetector(
              onTap: (){
                setState(() {
                  _selectedColor=index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:CircleAvatar(
                  radius: 14,
                  backgroundColor: index==0?primaryClr:index==1?pinkClr:yellowClr,
                  child: _selectedColor==index?Icon(Icons.done,
                    color: Colors.white,
                    size: 16,):Container(),
                ) ,
              ),
            );
          }
          ),
        )
      ],);
  }
  _appBar(BuildContext context){
    return AppBar(
      elevation: 1,
      backgroundColor: context.theme.backgroundColor,
      leading:GestureDetector(
        onTap:(){
          Get.back();
        },
        child: Icon(Icons.arrow_back_ios,
          color: Get.isDarkMode?Colors.white:Colors.black,),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: AssetImage(
              "assets/images/tst.jpg"
          ),
        ),
        SizedBox(width: 20,),
      ],
    );
  }
  _getDateFromUser() async {
    DateTime? _pickerDate=await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2025));
    if(_pickerDate!=null){
      setState(() {
        _selectedDate=_pickerDate;

      });
    }else{
      print("It's a null date selected");
    }
  }
  _getTimeFromUser({required bool isStartTime}) async{
    var _pickedTime=await  _showTimePicker();
    String _formatedTime=_pickedTime.format(context);
    if(_pickedTime==null){
      print("Time not picked");
    }
    else if(isStartTime==true){
      setState(() {
        _startTime=_formatedTime;
      });
    }else if(isStartTime==false){
      setState(() {
        _endTime=_formatedTime;
      });
    }
  }
  _showTimePicker(){
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        //_startTime-->10:30 AM (Format)
        initialTime: TimeOfDay(hour: int.parse(_startTime.split(":")[0]),
            minute:int.parse(_startTime.split(":")[1].split(" ")[0]),)) ;
  }
}