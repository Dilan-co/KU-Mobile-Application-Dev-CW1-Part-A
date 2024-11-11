import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class StateController extends GetxController {
  Database? _database;
  RxString externalStoragePath = "".obs;
  RxString documentsDirectoryPath = "".obs;
  Future<bool>? loadingFuture;
  //Mobile or Tablet Size
  RxDouble deviceAppBarMultiplier = 1.0.obs;

  //Dropdown Lists
  List<Map<int, String>> xList = [];

  setDatabase(Database db) {
    _database = db;
    debugPrint("========= Database Set =========");
  }

  getDatabase() {
    return _database;
  }

  setExternalStoragePath(String path) {
    externalStoragePath(path);
    debugPrint(path);
  }

  getExternalStoragePath() {
    return externalStoragePath();
  }

  setDocumentsDirectoryPath(String path) {
    documentsDirectoryPath(path);
    debugPrint(path);
  }

  getDocumentsDirectoryPath() {
    return documentsDirectoryPath();
  }
}
