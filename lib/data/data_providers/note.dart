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
        (1, 'Ideas for Next Project', 'This note includes detailed brainstorming ideas for the next project. We could explore innovative features, discuss feasibility, and conduct a market analysis. Consider potential integrations with AI and machine learning, and examine the technical requirements and team roles needed for implementation. This could enhance our current offerings and create new value for users, aligning with our long-term goals.', 0, '2020-05-01 12:00:00', '2020-05-01 12:00:00'),
        (2, 'Meeting Notes - Q2 Goals', 'In this note, we discuss the quarterly goals, focusing on productivity and growth. Ideas include developing a new feature set that enhances user engagement and reduces friction in onboarding. Specific metrics were highlighted, including an increase in retention rate by 20%. Additionally, ideas on creating strategic partnerships with industry leaders were proposed, which could add to our competitive advantage.', 0, '2020-05-05 15:30:00', '2020-05-05 15:30:00'),
        (3, 'Team Stand-Up Notes', 'This note logs key points from today’s stand-up, focusing on progress updates, blockers, and next steps for each team member.', 1, '2020-05-30 09:00:00', '2020-05-30 09:00:00'),
        (4, 'Reading List - Tech Books', 'This note contains a reading list of essential tech books that cover advanced programming concepts, software design principles, and algorithms. Books like "Clean Code," "Design Patterns," and "The Pragmatic Programmer" offer insights into better code practices. These resources are perfect for building foundational knowledge and keeping up with industry standards.', 1, '2020-05-08 10:15:00', '2020-05-08 10:15:00'),
        (5, 'Design Workshop Summary', 'Summary of our recent design workshop, which focused on user-centered design and enhancing the UX. We covered topics such as accessibility, color theory, and interactive elements that make apps more intuitive. Attendees were encouraged to provide feedback, and we brainstormed design solutions that align with our brand’s voice and vision.', 0, '2020-05-10 09:45:00', '2020-05-10 09:45:00'),
        (6, 'App Feature Requests', 'Summarizes recent feature requests from users, such as dark mode, push notifications, and offline access. These are currently under consideration for future updates.', 0, '2020-05-28 14:45:00', '2020-05-28 14:45:00'),
        (7, 'Code Refactoring Checklist', 'This note includes a comprehensive checklist for code refactoring to ensure readability, maintainability, and performance optimization. It outlines best practices like removing redundant code, modularizing functions, and improving variable naming. Adopting these practices can significantly reduce technical debt and make future code updates easier.', 0, '2020-05-12 14:20:00', '2020-05-12 14:20:00'),
        (8, 'Client Feedback Summary', 'This note captures feedback received from recent client meetings. Clients praised the user interface but suggested improvements in loading times and customization options. They also expressed interest in a more personalized experience. We will assess these suggestions and prioritize them for upcoming releases.', 1, '2020-05-15 11:00:00', '2020-05-15 11:00:00'),
        (9, 'Team Building Activities', 'Outlining team building activities to foster collaboration and enhance communication. Suggestions include virtual workshops, monthly social hours, and problem-solving games. These activities aim to build a stronger, more connected team culture, which is essential for effective remote work collaboration.', 0, '2020-05-18 16:45:00', '2020-05-18 16:45:00'),
        (10, 'Quarterly Performance Analysis', 'Detailed analysis of the last quarter’s performance, highlighting key metrics such as user engagement, revenue growth, and customer satisfaction. Areas of improvement include reducing churn rate and enhancing the onboarding process. Strategic adjustments will be implemented in the next quarter.', 0, '2020-05-20 10:00:00', '2020-05-20 10:00:00'),
        (11, 'Product Roadmap - 2021', 'This note provides an overview of the 2021 product roadmap, outlining major milestones, feature rollouts, and key enhancements. We are planning to release updates that improve the platform’s scalability and introduce new tools for user analytics. Each milestone is aligned with company objectives for growth and user satisfaction.', 0, '2020-05-22 13:30:00', '2020-05-22 13:30:00'),
        (12, 'Bug Tracking and Resolution Plan', 'Describes the bug tracking and resolution plan implemented to enhance product stability. This includes assigning severity levels, prioritizing tasks, and creating a timeline for resolution. Each bug is logged and categorized, and regular updates ensure timely resolution to maintain product quality and user trust.', 1, '2020-05-25 09:10:00', '2020-05-25 09:10:00'),
        (13, 'Upcoming Deadlines', 'Lists important deadlines for the upcoming month, including project milestones, report submissions, and client presentations.', 0, '2020-06-01 11:15:00', '2020-06-01 11:15:00');""";

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

  Future<List<NoteModel>> fetchPinnedNotes() async {
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
