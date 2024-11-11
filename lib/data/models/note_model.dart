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
        noteId: map["user_id"],
        noteTitle: map["username"],
        noteText: map["password"],
        pinned: map["pin"],
        createdAt: map["created_at"],
        updatedAt: map["updated_at"],
      );
}
