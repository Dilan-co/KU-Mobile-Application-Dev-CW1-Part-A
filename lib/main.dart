import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:my_simple_note/controllers/state_controller.dart';
import 'package:my_simple_note/data/data_providers/note.dart';
import 'package:my_simple_note/data/models/note_model.dart';
import 'package:my_simple_note/data/services/database_service.dart';
import 'package:my_simple_note/presentation/screens/home_page.dart';
import 'package:my_simple_note/utils/constants/color.dart';
import 'package:my_simple_note/utils/constants/size.dart';
import 'package:my_simple_note/utils/constants/text_style.dart';
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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    generateNoteLists();
  }

  // Fetches and populates both all notes and pinned notes.
  void generateNoteLists() async {
    List<NoteModel> allNotes = await Note().fetchAllRecords();
    List<NoteModel> pinnedNotes = await Note().fetchPinnedNotes();
    stateController.setAllNotesList(allNotes);
    stateController.setPinnedNotesList(pinnedNotes);
  }

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
      home: FutureBuilder(
        future: Future.delayed(const Duration(milliseconds: 2000)),
        builder: (context, snapshot) {
          // Return HomePage after the delay
          if (snapshot.connectionState == ConnectionState.done) {
            return const HomePage();
          }
          // Show a loading indicator until the delay is over
          return Container(
              color: CFGTheme.bgColorScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: CFGColor.darkGrey,
                  ),
                  //
                  const SizedBox(height: 20),
                  //
                  Text("Notes loading . . .",
                      style: TextStyle(
                          color: CFGTextStyle.defaultFontColor,
                          fontFamily: CFGTextStyle.clashGrotesk,
                          fontSize: CFGTextStyle.smallTitleFontSize,
                          fontWeight: CFGTextStyle.regularFontWeight,
                          decoration: TextDecoration.none)),
                ],
              ));
        },
      ),
    );
  }
}
