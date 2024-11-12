class NoteModel {
  final int? noteId;
  final String? noteTitle;
  final String? noteText;
  final int pinned;
  final String? createdAt;
  final String? updatedAt;

  NoteModel({
    required this.noteId,
    required this.noteTitle,
    required this.noteText,
    required this.pinned,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromSqfliteDatabase(Map<String, dynamic> map) => NoteModel(
        noteId: map["note_id"],
        noteTitle: map["note_title"],
        noteText: map["note_text"],
        pinned: map["pinned"],
        createdAt: map["created_at"],
        updatedAt: map["updated_at"],
      );
}
