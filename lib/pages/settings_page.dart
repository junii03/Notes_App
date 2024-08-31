import 'package:flutter/material.dart';
import 'package:notes_application/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SETTINGS'),
        titleTextStyle: TextStyle(
          letterSpacing: 3,
          fontSize: 25,
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'App Theme',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 25,
                  ),
                ),
                DropdownButton<ThemeMode>(
                  isDense: true,
                  borderRadius: BorderRadius.circular(12),
                  value: themeProvider.themeMode,
                  isExpanded: true,
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  items: [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text(
                        'System Theme',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text(
                        'Dark Mode',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text(
                        'Light Mode',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ],
                  onChanged: (ThemeMode? mode) {
                    if (mode != null) {
                      themeProvider.setTheme(mode);
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
