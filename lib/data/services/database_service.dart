import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_simple_note/data/data_providers/notes_db.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:my_simple_note/controllers/state_controller.dart';

class DatabaseService {
  final StateController stateController = Get.find();

  Future<Database> get database async {
    // Debug print to check if the database is null
    debugPrint("_database is null: ${stateController.getDatabase() == null}");
    if (stateController.getDatabase() != null &&
        stateController.getDatabase()!.isOpen) {
      debugPrint("Database Exists");
      return stateController.getDatabase();
    } else {
      try {
        Database database;
        database = await initializeDatabase();
        stateController.setDatabase(database);
        debugPrint("Database Initialized");
        return database;
      } catch (e) {
        debugPrint("Error initializing database: $e");
        rethrow;
      }
    }
  }
}

Future<String> get fullPath async {
  const dbName = "notes.db";
  final path = await getDatabasesPath();
  return join(path, dbName);
}

Future<Database> initializeDatabase() async {
  final path = await fullPath;
  var database = await openDatabase(
    path,
    version: 1,
    onCreate: createDatabase,
    singleInstance: true,
  );
  return database;
}

Future<void> createDatabase(Database database, int version) async {
  try {
    //Enable Foreign Keys
    await database.execute('PRAGMA foreign_keys = ON;');
    await NotesDB().createTables(database: database);
    debugPrint("Tables created successfully.");
  } catch (e) {
    debugPrint("Error creating tables: $e");
    rethrow;
  }
}
