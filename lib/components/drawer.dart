import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              child: Icon(
            Icons.sticky_note_2_outlined,
            size: 80,
            color: Theme.of(context).colorScheme.onSurface,
          )),

          // notes tile
          DrawerTile(
            title: 'Notes',
            leading: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () => Navigator.pop(context),
          ),

          // settings tile
          DrawerTile(
            title: 'Settings',
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
          Spacer(),
          // exit tile
          DrawerTile(
            title: 'Exit',
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onTap: () => SystemNavigator.pop(),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
    );
  }
}
