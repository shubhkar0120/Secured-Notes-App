Secure Notes App
A minimal yet secure Flutter application that allows users to store and manage personal text notes protected by a 4-digit PIN.
Features
PIN Security

First-time setup requiring users to create a 4-digit PIN
Secure storage of PIN using SHA-256 hashing to prevent unauthorized access
PIN authentication on app startup
Session-based authentication that persists until app restart

Notes Management

Create new notes with title and content
View a list of notes with preview snippets
Edit existing notes to update content
Delete notes with confirmation dialog
Automatic sorting of notes by last modified date

User Interface

Clean, intuitive, and modern Material Design-based UI
Smooth transitions between screens
Dark/Light theme support with toggle
Responsive layout that works across device sizes

Security Features

PIN reset option ("Forgot PIN?") with full data wipe for security
Proper handling of sensitive data
Secure local storage for user notes
PIN verification with anti-brute force measures

Project Architecture
The app follows a clean architecture approach with a focus on separation of concerns:
Models

Note: Data model for storing notes with properties like id, title, content, and timestamps

Services

SecureStorageService: Handles PIN storage, verification, and authentication
NotesService: Manages note CRUD operations and persistence
ThemeProvider: Manages app theme state and preferences

Screens

PinSetupScreen: First-run screen for creating a PIN
PinEntryScreen: Authentication screen for entering PIN
NotesListScreen: Main screen showing all notes
NoteEditScreen: Screen for creating or editing notes

Widgets

PinKeyboard: Custom widget for PIN entry
NoteCard: Card widget for displaying note preview
ConfirmDialog: Reusable confirmation dialog

Implementation Details
Security Implementation

PIN hashing using SHA-256 with a salt to prevent rainbow table attacks
No plain-text storage of sensitive information
Session-based authentication
Complete data wipe on PIN reset

Data Persistence

Notes are stored locally using SharedPreferences with JSON serialization
PIN is stored using secure storage (flutter_secure_storage package)
Theme preference is persisted between app sessions

State Management

Provider package for app-wide state management
Clean separation of UI and business logic
Service-based architecture for data operations

Getting Started
Prerequisites

Flutter SDK (latest version recommended)
Dart SDK (latest version recommended)
Android Studio / VS Code with Flutter extensions

Installation

Clone the repository
Run flutter pub get to install dependencies
Connect a device or start an emulator
Run flutter run to start the app

Dependencies
yamldependencies:
  flutter:
    sdk: flutter
  flutter_secure_storage: ^8.0.0   # For secure PIN storage
  shared_preferences: ^2.1.0       # For notes storage
  provider: ^6.0.5                 # For state management
  crypto: ^3.0.3                   # For PIN hashing
  intl: ^0.18.0                    # For date formatting
Security Considerations

PIN Storage: The PIN is hashed using SHA-256 with a salt before storage, ensuring that even if the storage is compromised, the PIN cannot be easily retrieved.
Session Management: The app maintains an authentication session that persists until the app is closed, preventing the need for frequent PIN entry while still maintaining security.
Data Protection: All notes are stored locally on the device, minimizing exposure to network-based attacks.
Reset Mechanism: The "Forgot PIN?" option securely wipes all data, preventing unauthorized access attempts.

UI/UX Design Principles

Minimalism: The UI is clean and focused, emphasizing content over decoration.
Consistency: UI elements maintain consistent styling and behavior throughout the app.
Feedback: The app provides clear feedback for user actions, including visual cues and confirmation dialogs.
Accessibility: Text sizes, contrast ratios, and touch targets are designed with accessibility in mind.

Future Enhancements

Biometric authentication (fingerprint/face recognition) as an alternative to PIN
End-to-end encryption for notes
Cloud backup options
Note categories/tags for better organization
Rich text formatting support
Attachments (images, documents) support
Search functionality
Export/import notes functionality
Auto-lock timer settings

Code Quality Practices

Consistent code formatting
Proper error handling
Comprehensive comments
Clear separation of concerns
Reusable components
Proper state management
