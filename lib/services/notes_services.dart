// lib/services/notes_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NotesService extends ChangeNotifier {
  final SharedPreferences _prefs;
  final String _notesKey = 'user_notes';
  List<Note> _notes = [];

  NotesService(this._prefs) {
    _loadNotes();
  }

  List<Note> get notes => List.unmodifiable(_notes);


  void _loadNotes() {
    final notesJson = _prefs.getString(_notesKey);
    if (notesJson != null) {
      final List<dynamic> decoded = json.decode(notesJson);
      _notes = decoded.map((item) => Note.fromJson(item)).toList();
      _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); 
    }
    notifyListeners();
  }

  Future<void> _saveNotes() async {
    final notesJson = json.encode(_notes.map((note) => note.toJson()).toList());
    await _prefs.setString(_notesKey, notesJson);
    notifyListeners();
  }

  Future<void> addNote(String title, String content) async {
    final newNote = Note.create(title: title, content: content);
    _notes.add(newNote);
    _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); 
    await _saveNotes();
  }

  Future<void> updateNote(String id, String title, String content) async {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(
        title: title,
        content: content,
      );
      _notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt)); 
      await _saveNotes();
    }
  }


  Future<void> deleteNote(String id) async {
    _notes.removeWhere((note) => note.id == id);
    await _saveNotes();
  }

  Future<void> clearAllNotes() async {
    _notes = [];
    await _saveNotes();
  }

  Note? getNote(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }
}
