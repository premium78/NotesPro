import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/note_service.dart';

class NoteProvider extends ChangeNotifier {
  final NoteService _service = NoteService();

  List<Note> _notes = [];
  List<Note> _trashedNotes = [];
  bool _isGridView = true;
  String _searchQuery = '';

  List<Note> get notes => _searchQuery.isEmpty
      ? _notes
      : _notes
          .where((note) =>
              note.title
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              note.content
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();

  List<Note> get trashedNotes => _trashedNotes;
  bool get isGridView => _isGridView;
  String get searchQuery => _searchQuery;

  void loadNotes() {
    _notes = _service.getAllNotes();
    _trashedNotes = _service.getDeletedNotes();
    notifyListeners();
  }

  Future<Note> createNote() async {
    final note = await _service.createNote();
    loadNotes();
    return note;
  }

  Future<void> updateNote(Note note) async {
    await _service.updateNote(note);
    loadNotes();
  }

  Future<void> moveToTrash(Note note) async {
    await _service.moveToTrash(note);
    loadNotes();
  }

  Future<void> restoreNote(Note note) async {
    await _service.restoreNote(note);
    loadNotes();
  }

  Future<void> deleteNotePermanently(Note note) async {
    await _service.deleteNotePermanently(note);
    loadNotes();
  }

  Future<void> emptyTrash() async {
    await _service.emptyTrash();
    loadNotes();
  }

  void toggleView() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}