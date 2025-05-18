
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'screens/pin_setup_screen.dart';
import 'screens/pin_entry_screen.dart';
import 'screens/notes_list_screen.dart';
import 'services/notes_services.dart';
import 'services/secure_storage.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Force portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize services
  final secureStorage = SecureStorageService(FlutterSecureStorage());
  final prefs = await SharedPreferences.getInstance();
  final notesService = NotesService(prefs);
  
  // Check if PIN is already set
  final hasPIN = await secureStorage.hasPIN();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider(prefs)),
        Provider.value(value: secureStorage),
        ChangeNotifierProvider(create: (_) => notesService),
      ],
      child: SecureNotesApp(initialScreen: hasPIN ? 'pin_entry' : 'pin_setup'),
    ),
  );
}

// Added the SecureNotesApp class definition
class SecureNotesApp extends StatelessWidget {
  final String initialScreen;
  
  const SecureNotesApp({Key? key, required this.initialScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'Secure Notes',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      initialRoute: initialScreen,
      routes: {
        'pin_setup': (context) => const PinSetupScreen(),
        'pin_entry': (context) => const PinEntryScreen(),
        'notes_list': (context) => const NotesListScreen(),
      },
    );
  }
}