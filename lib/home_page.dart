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
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
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
              icon: Icon(Icons.help_outline),
              onPressed: () {
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
            const SizedBox(height: 70),
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
