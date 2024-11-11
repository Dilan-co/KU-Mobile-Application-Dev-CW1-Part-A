import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import 'package:my_simple_note/controllers/state_controller.dart';

final StateController stateController = Get.find();

Future<void> localStoragePath() async {
  //Only for Android
  if (Platform.isAndroid) {
    final externalStorageDir = await getExternalStorageDirectory();
    await stateController.setExternalStoragePath(externalStorageDir!.path);

    createExternalStorageFolder();
  }
  //For both IOS and Android
  final appDocumentsDir = await getApplicationDocumentsDirectory();
  await stateController.setDocumentsDirectoryPath(appDocumentsDir.path);
}

Future<void> createExternalStorageFolder() async {
  try {
    // Get the application documents directory
    String externalStorageDir = await stateController.getExternalStoragePath();

    // Create a reference to the new folder
    Directory newFolder = Directory(externalStorageDir);

    // Check if the folder already exists
    if (!(await newFolder.exists())) {
      // Create the folder if it doesn't exist
      await newFolder.create(recursive: true);
      debugPrint("Folder created: ${newFolder.path}");
    } else {
      debugPrint("Folder already exists: ${newFolder.path}");
    }
  } catch (e) {
    debugPrint("Error creating folder: $e");
  }
}
