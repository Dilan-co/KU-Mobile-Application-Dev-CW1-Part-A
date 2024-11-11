import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'package:my_simple_note/data/models/note_model.dart';
import 'package:my_simple_note/data/services/database_service.dart';

class Note {
  //Table name
  final tableName = 'Notes';

  Future<void> createTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $tableName (
      "note_id" INTEGER NOT NULL,
      "note_title" TEXT DEFAULT NULL,
      "note_text" TEXT DEFAULT NULL,
      "pinned" INTEGER NOT NULL DEFAULT 0, -- Pinned to dashboard. YES 1, NO 0,
      "created_at" TEXT DEFAULT NULL,
      "updated_at" TEXT DEFAULT NULL,
      PRIMARY KEY("note_id" AUTOINCREMENT)
    );""");
    int index = await addRecords();

    debugPrint("Notes addRecords Done. Records count: $index");
  }

  Future<int> addRecords() async {
    final database = await DatabaseService().database;

    try {
      // SQL query to add data
      String query =
          """INSERT INTO $tableName (note_id, note_title, note_text, pinned, created_at, updated_at) VALUES 
        (1, 'Title 1', 'Text inside note', 0, '2020-04-22 23:25:06', '2020-04-22 23:25:06');""";

      return await database.rawInsert(query);
    } catch (e) {
      debugPrint('Error adding data to Notes: $e');
      return -1;
    }
  }

  Future<int> createRecord({required NoteModel model}) async {
    final database = await DatabaseService().database;

    debugPrint("createRecord Done");

    return await database.insert(tableName, {
      "note_id": model.noteId,
      "note_title": model.noteTitle,
      "note_text": model.noteText,
      "pinned": model.pinned,
      "created_at": model.createdAt,
      "updated_at": model.updatedAt,
    });
  }

  Future<List<NoteModel>> fetchAllRecords() async {
    final database = await DatabaseService().database;

    final data = await database.rawQuery(
        """SELECT * from $tableName ORDER BY COALESCE(note_id, note_title, note_text, pinned, created_at, updated_at);""");

    debugPrint("fetchAllRecords Done");

    return data.map((data) => NoteModel.fromSqfliteDatabase(data)).toList();
  }

  Future<NoteModel> fetchById({required int noteId}) async {
    final database = await DatabaseService().database;
    final data = await database
        .rawQuery("""SELECT * from $tableName WHERE note_id = ?""", [noteId]);

    debugPrint("fetchById Done");

    return NoteModel.fromSqfliteDatabase(data.first);

    //To get a list of data <List<NoteModel>>
    // return data.map((data) => NoteModel.fromSqfliteDatabase(data))
    //     .toList();
  }

  Future<List<NoteModel>> fetchPinnedNotes({required int noteId}) async {
    final database = await DatabaseService().database;
    final data = await database
        .rawQuery("""SELECT * from $tableName WHERE pinned = ?""", [1]);

    debugPrint("fetchPinnedNotes Done");

    //To get a list of data <List<NoteModel>>
    return data.map((data) => NoteModel.fromSqfliteDatabase(data)).toList();
  }

  Future<int> updateRecord({required NoteModel model}) async {
    final database = await DatabaseService().database;

    debugPrint("updateRecord Done");

    return await database.update(
      tableName,
      {
        "note_id": model.noteId,
        "note_title": model.noteTitle,
        "note_text": model.noteText,
        "pinned": model.pinned,
        "created_at": model.createdAt,
        "updated_at": model.updatedAt,
      },
      where: "note_id = ?",
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [model.noteId],
    );
  }

  Future<int> deleteRecord({required NoteModel model}) async {
    final database = await DatabaseService().database;

    int recordId = await database
        .delete(tableName, where: "note_id = ?", whereArgs: [model.noteId]);

    debugPrint("deleteRecord Done");
    return recordId;
  }
}
