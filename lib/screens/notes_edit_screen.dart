// lib/screens/note_edit_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secured_notes_app/services/notes_services.dart';
import '../widgets/confirm_dialog.dart';

class NoteEditScreen extends StatefulWidget {
  final String? noteId;
  
  const NoteEditScreen({Key? key, this.noteId}) : super(key: key);

  @override
  State<NoteEditScreen> createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    
    _isEditing = widget.noteId != null;
    
    if (_isEditing) {
      // Load existing note data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final notesService = Provider.of<NotesService>(context, listen: false);
        final note = notesService.getNote(widget.noteId!);
        
        if (note != null) {
          _titleController.text = note.title;
          _contentController.text = note.content;
        }
      });
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Note' : 'New Note'),
        leading: BackButton(onPressed: _handleBack),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Type your note here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: null,
                  expands: true,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter some content';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNote() async {

    if (_formKey.currentState?.validate() != true) {
      return;
    }
    
    final notesService = Provider.of<NotesService>(context, listen: false);
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    
    if (_isEditing) {
 
      await notesService.updateNote(widget.noteId!, title, content);
    } else {
      await notesService.addNote(title, content);
    }
    
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> _handleBack() async {
    
    final notesService = Provider.of<NotesService>(context, listen: false);
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    
    bool hasChanges = false;
    
    if (_isEditing) {
      final note = notesService.getNote(widget.noteId!);
      if (note != null) {
        hasChanges = title != note.title || content != note.content;
      }
    } else {
      hasChanges = title.isNotEmpty || content.isNotEmpty;
    }
    
    if (!hasChanges) {
      Navigator.pop(context);
      return;
    }

    final result = await ConfirmDialog.show(
      context: context,
      title: 'Discard Changes',
      message: 'Are you sure you want to discard your changes?',
      confirmText: 'DISCARD',
      cancelText: 'KEEP EDITING',
    );
    
    if (result == true && mounted) {
      Navigator.pop(context);
    }
  }
}