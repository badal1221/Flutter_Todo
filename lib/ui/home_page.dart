import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_flutter/services/theme_services.dart';
import 'package:todo_app_flutter/ui/add_task_bar.dart';
import 'package:todo_app_flutter/ui/theme.dart';
import 'package:todo_app_flutter/ui/widgets/button.dart';

import '../services/notification_services.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key?key}):super(key:key);

  @override
  State<StatefulWidget> createState()=>_HomePageState();
}
class _HomePageState extends State<Homepage>{
  DateTime _selectedDate=DateTime.now();
  var notifyHelper;
  @override
  void initState(){
    super.initState();
    notifyHelper=NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _appBar(),
      body:Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
        ],
      )
    );
  }
  _addDateBar(){
    return Container(
      margin: const EdgeInsets.only(top: 20,left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle:GoogleFonts.lato(
          textStyle:TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle:GoogleFonts.lato(
          textStyle:TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle:GoogleFonts.lato(
          textStyle:TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date){
          _selectedDate=date;
        },
      ),
    );
  }
  _addTaskBar(){
    return Container(
      margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today",style:HeadingStyle,),
              ],
            ),
          ),
          MyButton(label:"+Add Task",onTap:()=>Get.to(AddTaskPage())),
        ],
      ),
    );
  }
  _appBar(){
    return AppBar(
      elevation: 1,
      backgroundColor: context.theme.backgroundColor,
      leading:GestureDetector(
        onTap:(){
            ThemeService().switchTheme();
            notifyHelper.displayNotification(title:"Theme Changed",
                body: Get.isDarkMode?"Activated Light Theme":"Activated Dark Theme");
            //notifyHelper.scheduledNotification();
        },
        child: Icon(Get.isDarkMode?Icons.wb_sunny_outlined:Icons.nightlight_round,size: 20,
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
}