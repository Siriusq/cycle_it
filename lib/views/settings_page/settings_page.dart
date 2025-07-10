import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Container(
        child: Column(
          children: [
            ListTile(title: Text('languageSettingsText'.tr), onTap: () {}),
            ListTile(title: Text("Theme Settings"), onTap: () {}),
            ListTile(title: Text("Color Settings"), onTap: () {}),
            ListTile(title: Text("Database Settings"), onTap: () {}),
            ListTile(title: Text("Tags Settings"), onTap: () {}),
          ],
        ),
      ),
    );
  }
}
