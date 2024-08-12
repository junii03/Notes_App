import 'package:flutter/material.dart';
import 'package:notes_application/components/drawer_tile.dart';
import 'package:notes_application/pages/settings_page.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // header
          DrawerHeader(
            child: Image.asset(
              'assets/logo.png',
              scale: 1,
              color: Theme.of(context).colorScheme.surface,
              colorBlendMode: BlendMode.hardLight,
              fit: BoxFit.scaleDown,
            ),
          ),

          // notes tile
          DrawerTile(
            title: 'Notes',
            leading: Icon(Icons.home,color: Theme.of(context).colorScheme.onSurface,),
            onTap: () => Navigator.pop(context),
          ),

          // settings tile
          DrawerTile(
            title: 'Settings',
            leading: Icon(Icons.settings,color: Theme.of(context).colorScheme.onSurface,),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
    );
  }
}
