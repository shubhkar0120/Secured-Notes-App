# Secure Notes App

A minimal yet secure Flutter application that allows users to store and manage personal text notes protected by a 4-digit PIN.

---

## Features

### PIN Security
- First-time setup requiring users to create a 4-digit PIN
- Secure storage using SHA-256 hashing with salt (no plain-text storage)
- PIN authentication on every app launch
- Session-based access that stays active until app is restarted

### Notes Management
- Create new notes with title and content
- View a list of notes with preview snippets
- Edit existing notes to update content
- Delete notes with confirmation dialog
- Notes automatically sorted by last modified date

### User Interface
- Clean and modern Material Design-based UI
- Smooth navigation and transitions
- Dark/Light theme support with toggle
- Fully responsive layout across device sizes

### Security Features
- “Forgot PIN?” resets app with full data wipe
- Proper handling of sensitive data
- Secure local storage for user notes
- Anti-brute force: basic validation strategy

---

## Project Architecture

### Models
- `Note`: Data model for storing id, title, content, and timestamps

### Services
- `SecureStorageService`: Handles PIN storage/verification
- `NotesService`: CRUD operations for notes
- `ThemeProvider`: Manages app theme state

### Screens
- `PinSetupScreen`: First-run screen to create a PIN
- `PinEntryScreen`: Login screen for authentication
- `NotesListScreen`: List all saved notes
- `NoteEditScreen`: Create or modify notes

### Widgets
- `PinKeyboard`: Custom numeric keypad
- `NoteCard`: Note preview widget
- `ConfirmDialog`: Confirmation popup component

---

## Security Implementation

- PINs hashed using SHA-256 with salt before storage
- No plain-text sensitive data stored
- Authentication session lasts until app is closed
- “Forgot PIN?” securely clears all app data

---

## Data Persistence

- Notes stored locally via `SharedPreferences` (JSON format)
- PIN stored using `flutter_secure_storage`
- Theme mode preference saved across sessions

---

## State Management

- `provider` package for state management
- Clear separation of concerns via services
- UI remains decoupled from business logic

---

## Getting Started

### Prerequisites
- Flutter SDK (latest)
- Dart SDK (latest)
- Android Studio or VS Code with Flutter support

### Installation
```bash
git clone https://github.com/your-username/secure-notes-app.git
cd secure-notes-app
flutter pub get
flutter run
