import 'package:sqflite/sqflite.dart';

import 'package:my_simple_note/data/data_providers/note.dart';

class NotesDB {
  //Creating tables for forms
  Future<void> createTables({required Database database}) async {
    //Add all tables for Forms here
    Note().createTable(database);
  }
}
