import 'package:flutter/material.dart';
import 'package:insulin_wizard/home_page.dart';
import 'package:insulin_wizard/calculator/step_1/calc_step_one.dart';
import 'package:insulin_wizard/disclaimer.dart';
import 'package:insulin_wizard/onboarding.dart';
import 'package:insulin_wizard/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool acceptedDisclaimer = prefs.getBool('acceptedDisclaimer') ?? false;

  runApp(InsulinCalcApp(acceptedDisclaimer: acceptedDisclaimer));
}

class InsulinCalcApp extends StatefulWidget {
  final bool acceptedDisclaimer;
  const InsulinCalcApp({super.key, required this.acceptedDisclaimer});

  @override
  _InsulinCalcAppState createState() => _InsulinCalcAppState();
}

class _InsulinCalcAppState extends State<InsulinCalcApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: widget.acceptedDisclaimer
          ? CalculatorHomePage(toggleTheme: _toggleTheme, themeMode: _themeMode)
          : const OnboardingScreen(),
theme: ThemeData(
        fontFamily: 'Coolvetica',
        brightness: Brightness.light,
        useMaterial3: true,
        primaryColor: Colors.white,
        cardColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red.shade700),
            foregroundColor: MaterialStateProperty.all(Colors.white)
          )
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.red,
          secondary: Colors.red,
        ),
      ),
      darkTheme: ThemeData(
        fontFamily: 'Coolvetica',
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: Colors.black87,
        cardColor: Colors.black,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red.shade700),
          )
        ),
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.red,
        ),
      ),
      themeMode: _themeMode,
      routes: {
        '/calc': (context) => const CalcStepOne(),
        '/disclaimer': (context) => const Disclaimer(),
        '/settings': (context) =>
            SettingsPage(toggleTheme: _toggleTheme, themeMode: _themeMode),
        '/home': (context) => CalculatorHomePage(
            toggleTheme: _toggleTheme, themeMode: _themeMode),
      },
    );
  }
}
