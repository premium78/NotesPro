import 'package:hive_flutter/hive_flutter.dart';
import '../models/note_model.dart';

class NoteService {
  static const String _boxName = 'notes';

  Box<Note> get _box => Hive.box<Note>(_boxName);

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(NoteAdapter());
    await Hive.openBox<Note>(_boxName);
  }

  List<Note> getAllNotes() {
    return _box.values
        .where((note) => !note.isDeleted)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  List<Note> getDeletedNotes() {
    return _box.values
        .where((note) => note.isDeleted)
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<Note> createNote() async {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '',
      content: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _box.put(note.id, note);
    return note;
  }

  Future<void> updateNote(Note note) async {
    note.updatedAt = DateTime.now();
    await note.save();
  }

  Future<void> moveToTrash(Note note) async {
    note.isDeleted = true;
    note.updatedAt = DateTime.now();
    await note.save();
  }

  Future<void> restoreNote(Note note) async {
    note.isDeleted = false;
    note.updatedAt = DateTime.now();
    await note.save();
  }

  Future<void> deleteNotePermanently(Note note) async {
    await note.delete();
  }

  Future<void> emptyTrash() async {
    final deletedNotes = getDeletedNotes();
    for (final note in deletedNotes) {
      await note.delete();
    }
  }
}