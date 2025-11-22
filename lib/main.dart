import 'package:flutter/material.dart';
import 'inherited/notes_wrapper.dart';
import 'screens/login_screen.dart';
import 'screens/notes_screen.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  bool loggedIn = false;

  void _login() => setState(() => loggedIn = true);
  void _logout() => setState(() => loggedIn = false);

  @override
  Widget build(BuildContext context) {
    return NotesWrapper(
      child: MaterialApp(
        title: 'Notes App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: loggedIn
            ? NotesScreen(onLogout: _logout)
            : LoginScreen(onLogin: _login),
      ),
    );
  }
}
