import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

enum Choices { BackupOn, BackupOff }

class _SettingsState extends State<Settings> {
  Choices choice = Choices.BackupOff;
  bool isBackUpOn = false;
  bool isDarkOn = false;
  var backupTitle = 'Backup Off';
  var backupTileColor = Colors.red;

  toggleBackup(bool value) {
    if (isBackUpOn) {
      setState(() {
        isBackUpOn = false;
        backupTitle = 'Backup Off';
        backupTileColor = Colors.red;
      });
    } else {
      setState(() {
        isBackUpOn = true;
        backupTitle = 'Backup On';
        backupTileColor = Colors.green;
      });
    }
  }

  toggleTheme(bool value) {
    if (isDarkOn) {
      setState(() {
        isDarkOn = false;
      });
    } else {
      setState(() {
        isDarkOn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          ListTile(
            tileColor: backupTileColor,
            onTap: () {
              isBackUpOn ? toggleBackup(false) : toggleBackup(true);
            },
            title: Text(
              backupTitle,
              style: TextStyle(fontSize: 18),
            ),
            leading: FaIcon(
              FontAwesomeIcons.blog,
              color: Colors.black,
            ),
            trailing: Switch(
              onChanged: toggleBackup,
              value: isBackUpOn,
            ),
          ),
          ListTile(
              onTap: () {
                isDarkOn ? toggleTheme(false) : toggleTheme(true);
              },
              title: Text(
                'Dark Theme',
                style: TextStyle(fontSize: 18),
              ),
              leading: FaIcon(
                FontAwesomeIcons.moon,
                color: Colors.black,
              ),
              trailing: Switch(
                onChanged: toggleTheme,
                value: isDarkOn,
              ))
        ],
      ),
    );
  }
}
