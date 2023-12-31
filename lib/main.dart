import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo_app_flutter/db/db_helper.dart';
import 'package:todo_app_flutter/services/theme_services.dart';
import 'package:todo_app_flutter/splash_screen.dart';
import 'package:todo_app_flutter/ui/home_page.dart';
import 'package:todo_app_flutter/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme:Themes.dark,
      themeMode: ThemeService().theme,
      home: SplashScreen()
    );
  }
}

