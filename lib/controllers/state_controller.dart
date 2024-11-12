import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_simple_note/data/models/note_model.dart';
import 'package:sqflite/sqflite.dart';

class StateController extends GetxController {
  Database? _database;
  RxString externalStoragePath = "".obs;
  RxString documentsDirectoryPath = "".obs;
  Future<bool>? loadingFuture;
  RxList<NoteModel> allNotesList = <NoteModel>[].obs;
  RxList<NoteModel> pinnedNotesList = <NoteModel>[].obs;

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

  setAllNotesList(List<NoteModel> list) {
    allNotesList(list);
  }

  getAllNotesList() {
    return allNotesList();
  }

  setPinnedNotesList(List<NoteModel> list) {
    pinnedNotesList(list);
  }

  getPinnedNotesList() {
    return pinnedNotesList();
  }
}
