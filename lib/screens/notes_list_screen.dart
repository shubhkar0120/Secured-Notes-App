
// lib/screens/notes_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secured_notes_app/services/notes_services.dart';
import '../models/note.dart';
import '../services/secure_storage.dart';
import '../widgets/note_card.dart';
import '../utils/theme.dart';
import 'notes_edit_screen.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final secureStorage = Provider.of<SecureStorageService>(context, listen: false);
      if (!secureStorage.isAuthenticated()) {
        Navigator.pushReplacementNamed(context, 'pin_entry');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final notesService = Provider.of<NotesService>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Notes'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: notesService.notes.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              itemCount: notesService.notes.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final note = notesService.notes[index];
                return NoteCard(
                  note: note,
                  onTap: () => _editNote(note),
                  onDelete: () => _deleteNote(note.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 72,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Notes Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first note',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  void _createNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NoteEditScreen(),
      ),
    );
    
    if (result == true) {
      // Note was saved, no need to do anything since the provider
      // will update the UI automatically
    }
  }

  void _editNote(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditScreen(noteId: note.id),
      ),
    );
    
    if (result == true) {
      // Note was updated, no need to do anything since the provider
      // will update the UI automatically
    }
  }

  void _deleteNote(String id) {
    final notesService = Provider.of<NotesService>(context, listen: false);
    notesService.deleteNote(id);
  }

  void _handleLogout() {
    final secureStorage = Provider.of<SecureStorageService>(context, listen: false);
    secureStorage.resetAuthentication();
    Navigator.pushReplacementNamed(context, 'pin_entry');
  }
}
