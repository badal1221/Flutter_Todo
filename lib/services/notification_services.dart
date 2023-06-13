import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app_flutter/models/task.dart';
import 'package:todo_app_flutter/ui/notified_page.dart';

class NotifyHelper{
  FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    //tz.initializeTimeZones();
    _configureLocalTimezone();
    // this is for latest iOS settings
    final DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );

    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings("appicon");

    final InitializationSettings initializationSettings =
    InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        /*onSelectNotification: selectNotification*/);

  }
  displayNotification({required String title, required String body}) async {
    print("doing test");
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name'/*, 'your channel description'*/,
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new DarwinNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }
  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  scheduledNotification(int hour,int minutes,Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.note,
         _convertTime(hour,minutes),
        //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name'/*, 'your channel description'*/)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents:DateTimeComponents.time,
    payload: "${task.title}|"+"${task.note}|");
  }
  Future selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    } else {
      print("Notification Done");
    }
    if(payload=="Theme Changed"){
      print("Eat 5 star");
    }
    else{
      Get.to(()=>NotifiedPage(label:payload));
    }
  }
  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(Text("Welcome to Flutterrr"));
  }
  tz.TZDateTime _convertTime(int hour,int minutes){
    final tz.TZDateTime now=tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate=tz.TZDateTime(tz.local,now.year,now.month,now.day,hour,minutes);
    print("tz is  $scheduleDate");
    if(scheduleDate.isBefore(now)){
      scheduleDate=scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }
  Future<void> _configureLocalTimezone()async{
    tz.initializeTimeZones();
    final String timeZone= await DateTime.now().timeZoneName;
    print(timeZone);
    tz.setLocalLocation(tz.getLocation(timeZone));
  }
}