// lib/screens/pin_setup_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/secure_storage.dart';
import '../widgets/pin_keyboard.dart';

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({Key? key}) : super(key: key);

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String _enteredPin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _errorMessage = '';

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
              _isConfirming ? 'Confirm PIN' : 'Create a PIN',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _isConfirming
                  ? 'Please re-enter your PIN to confirm'
                  : 'Enter a 4-digit PIN to secure your notes',
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
              showSubmitButton: _getCurrentPin().length == 4,
              onSubmit: _getCurrentPin().length == 4 ? _handleSubmit : null,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPinDot(int position) {
    final isFilled = position < _getCurrentPin().length;
    
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

  String _getCurrentPin() {
    return _isConfirming ? _confirmPin : _enteredPin;
  }

  void _setCurrentPin(String pin) {
    setState(() {
      if (_isConfirming) {
        _confirmPin = pin;
      } else {
        _enteredPin = pin;
      }
      _errorMessage = '';
    });
  }

  void _handleKeyPress(String key) {
    final currentPin = _getCurrentPin();
    if (currentPin.length < 4) {
      _setCurrentPin(currentPin + key);
    }
  }

  void _handleDelete() {
    final currentPin = _getCurrentPin();
    if (currentPin.isNotEmpty) {
      _setCurrentPin(currentPin.substring(0, currentPin.length - 1));
    }
  }

  void _handleSubmit() async {
    if (_isConfirming) {
      if (_confirmPin == _enteredPin) {
        try {
          // PIN matches, save it
          final secureStorage = Provider.of<SecureStorageService>(context, listen: false);
          await secureStorage.setupPIN(_enteredPin);
          
          // Navigate to notes list
          if (mounted) {
            Navigator.pushReplacementNamed(context, 'notes_list');
          }
        } catch (e) {
          setState(() {
            _errorMessage = e.toString();
            _confirmPin = '';
          });
        }
      } else {
        // PINs don't match
        setState(() {
          _errorMessage = 'PINs do not match. Please try again.';
          _isConfirming = false;
          _enteredPin = '';
          _confirmPin = '';
        });
      }
    } else {
      // Proceed to confirmation
      setState(() {
        _isConfirming = true;
      });
    }
  }
}
