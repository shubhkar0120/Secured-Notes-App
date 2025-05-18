import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  final String _pinKey = 'user_pin';
  bool _isAuthenticated = false;

  SecureStorageService(this._storage);

  Future<bool> hasPIN() async {
    final pin = await _storage.read(key: _pinKey);
    return pin != null;
  }

  Future<void> setupPIN(String pin) async {
    if (pin.length != 4 || int.tryParse(pin) == null) {
      throw Exception('PIN must be a 4-digit number');
    }
    
    final hashedPin = _hashPIN(pin);
    await _storage.write(key: _pinKey, value: hashedPin);
    _isAuthenticated = true;
  }

  Future<bool> verifyPIN(String pin) async {
    final storedHashedPin = await _storage.read(key: _pinKey);
    if (storedHashedPin == null) return false;
    
    final inputHashedPin = _hashPIN(pin);
    _isAuthenticated = (inputHashedPin == storedHashedPin);
    return _isAuthenticated;
  }

  bool isAuthenticated() {
    return _isAuthenticated;
  }

  void resetAuthentication() {
    _isAuthenticated = false;
  }

  Future<void> resetApp() async {
    await _storage.deleteAll();
    _isAuthenticated = false;
  }

  String _hashPIN(String pin) {
    final bytes = utf8.encode(pin + 'secure_notes_salt');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
