import 'package:flutter/material.dart';
import 'package:notes_application/models/notes_database.dart';
import 'package:notes_application/pages/notes_page.dart';
import 'package:notes_application/theme/theme.dart';
import 'package:notes_application/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // initialize the notes isar db
  WidgetsFlutterBinding.ensureInitialized();

  await NotesDatabase.initialize();

  runApp(MultiProvider(
    providers: [
      //Note Provider
      ChangeNotifierProvider(create: (context) => NotesDatabase()),
      // Theme Provider
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NotesPage(),
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeProvider.themeMode,
    );
  }
}
