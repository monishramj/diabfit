//FIX THESE LATER!!

import 'package:flutter/material.dart';
import 'package:insulin_wizard/settings.dart';
//11:13:05

class CalculatorHomePage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final ThemeMode themeMode;

  const CalculatorHomePage(
      {super.key, required this.toggleTheme, required this.themeMode});

  @override
  State<CalculatorHomePage> createState() => CalculatorHomePageState();
}

class CalculatorHomePageState extends State<CalculatorHomePage> {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    // ignore: unused_local_variable
    final logoImage = brightness == Brightness.light
        ? 'assets/icons/logo_light_mode.png'
        : 'assets/icons/logo_dark_mode.png';

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      toggleTheme: widget.toggleTheme,
                      themeMode: widget.themeMode,
                    ),
                  ),
                );
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/disclaimer');
                },
                child: Text(
                  "Disclaimer",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).hintColor,
                    fontSize: 15,
                  ),
                )),
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("What is DiabFit?"),
                      content: const Text(
                          "Diabfit is a user-friendly app designed to help diabetics manage their daily health needs. It provides tools for tracking logging food intake, and managing insulin doses. Enter your carb intake for the day, and your blood glucose to easily calculate insulin doses."),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("OK"))
                      ],
                    );
                  },
                );
                // Navigate to instructions page
                //Navigator.push(
                // context,
                //MaterialPageRoute(builder: (context) => InstructionsPage()),
                //);
              },
            ),
          ],
        ),
      ),
      // backgroundColor: Color.fromARGB(255, 215, 206, 178),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 180,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.asset("assets/icons/app_icon.png"))),
            const SizedBox(height: 0),
            const Text(
              "DiabFit",
              style: TextStyle(
                fontSize: 80,
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/calc');
                },
                child: const Text(
                  "Start",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 10),
            //SizedBox(
            //  child: ElevatedButton(
            //    onPressed: () {
            //      Navigator.pushNamed(context, '/disclaimer');
            //    },
            //    child: const Text(
            //      "Disclaimer",
            //      style: TextStyle(fontSize: 30),
            //    ),
            //  ),
            //),
          ],
        ),
      ),
    );
  }
}
