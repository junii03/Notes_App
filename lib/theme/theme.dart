import 'package:flutter/material.dart';

// Light mode theme configuration
ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    onSurface: Colors.blueGrey.shade300,
    primary: Colors.blueGrey.shade500,
    onPrimary: Colors.blueGrey.shade700,
    secondary: Colors.blueGrey.shade100,
    onSecondary: Colors.grey.shade500,
    error: Colors.red.shade400,
  ),
);


ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900, // Background for Scaffold and main body
    onSurface: Colors.blueGrey.shade200, // Text/icons on surface background
    primary: Colors.blueGrey.shade700, // Primary color for UI elements
    onPrimary: Colors.blueGrey.shade100, // Text/icons on primary color
    secondary: Colors.blueGrey.shade900, // Color for cards, dialogs, etc.
    onSecondary: Colors.grey.shade300, // Text/icons on secondary color
    error: Colors.red.shade700, // Error color (e.g., for delete button)
  ),
);