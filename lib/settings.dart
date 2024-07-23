import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final ThemeMode themeMode;

  const SettingsPage({required this.toggleTheme, required this.themeMode, super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text("Settings"),
      centerTitle: true,
    ),
    body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Dark Mode', style: TextStyle(fontSize: 20),),
            Switch(
              value: widget.themeMode == ThemeMode.dark,
              onChanged: (value) {
                widget.toggleTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
