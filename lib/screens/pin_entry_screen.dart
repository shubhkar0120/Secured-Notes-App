
// lib/screens/pin_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notes_services.dart';
import '../services/secure_storage.dart';
import '../widgets/pin_keyboard.dart';
import '../widgets/confirm_dialog.dart';

class PinEntryScreen extends StatefulWidget {
  const PinEntryScreen({Key? key}) : super(key: key);

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _enteredPin = '';
  String _errorMessage = '';
  bool _isVerifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Icon(
              Icons.lock_outline,
              size: 72,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 32),
            Text(
              'Enter PIN',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter your 4-digit PIN to access your notes',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) => _buildPinDot(index),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const Spacer(),
            PinKeyboard(
              onKeyPressed: _handleKeyPress,
              onDelete: _handleDelete,
              showSubmitButton: _enteredPin.length == 4,
              onSubmit: _enteredPin.length == 4 ? _verifyPin : null,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _showResetConfirmation,
              child: const Text(
                'Forgot PIN?',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDot(int position) {
    final isFilled = position < _enteredPin.length;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isFilled
            ? Theme.of(context).primaryColor
            : Theme.of(context).disabledColor.withOpacity(0.3),
      ),
    );
  }

  void _handleKeyPress(String key) {
    if (_isVerifying) return;
    
    setState(() {
      if (_enteredPin.length < 4) {
        _enteredPin += key;
        _errorMessage = '';
      }
    });
    
    // Auto-verify when 4 digits are entered
    if (_enteredPin.length == 4) {
      _verifyPin();
    }
  }

  void _handleDelete() {
    if (_isVerifying) return;
    
    setState(() {
      if (_enteredPin.isNotEmpty) {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
        _errorMessage = '';
      }
    });
  }

  Future<void> _verifyPin() async {
    if (_isVerifying) return;
    
    setState(() {
      _isVerifying = true;
    });
    
    try {
      final secureStorage = Provider.of<SecureStorageService>(context, listen: false);
      final isValid = await secureStorage.verifyPIN(_enteredPin);
      
      if (isValid) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, 'notes_list');
        }
      } else {
        setState(() {
          _errorMessage = 'Incorrect PIN. Please try again.';
          _enteredPin = '';
          _isVerifying = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _enteredPin = '';
        _isVerifying = false;
      });
    }
  }

  Future<void> _showResetConfirmation() async {
    final result = await ConfirmDialog.show(
      context: context,
      title: 'Reset App',
      message: 'This will delete all your notes and reset your PIN. This action cannot be undone. Are you sure?',
      confirmText: 'RESET',
      cancelText: 'CANCEL',
    );
    
    if (result == true) {
      final secureStorage = Provider.of<SecureStorageService>(context, listen: false);
      final notesService = Provider.of<NotesService>(context, listen: false);
      
      // Reset PIN and clear notes
      await secureStorage.resetApp();
      await notesService.clearAllNotes();
      
      // Navigate to PIN setup screen
      if (mounted) {
        Navigator.pushReplacementNamed(context, 'pin_setup');
      }
    }
  }
}
