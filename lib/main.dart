import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:my_simple_note/controllers/state_controller.dart';
import 'package:my_simple_note/data/services/database_service.dart';
import 'package:my_simple_note/presentation/screens/dashboard.dart';
import 'package:my_simple_note/utils/constants/size.dart';
import 'package:my_simple_note/utils/constants/theme.dart';
import 'package:my_simple_note/utils/helpers/local_storage_path.dart';

void main() {
  // Splash Screen
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MainApp());

  initialization();
}

void initialization() async {
  // This is where you can initialize the resources needed by your app while the splash screen is displayed.

  //Status Bar & Nav Bar colors
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: CFGTheme.bgColorScreen,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: CFGTheme.bgColorScreen,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  //Initialize GetX State Controller
  Get.put(StateController());
  //Initialize SQFLite Database
  await DatabaseService().database;
  //Getting Local Storage Path
  localStoragePath();
  //Removing Splash Screen after initializing
  FlutterNativeSplash.remove();
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Initializing MediaQuery for padding
    CFGSize().init(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      home: const Dashboard(),
    );
  }
}
