import 'package:flutter/material.dart';
import 'package:insulin_wizard/calculator/calc_home_page.dart';
import 'package:insulin_wizard/calculator/step_1/calc_step_one.dart';
import 'package:insulin_wizard/disclaimer.dart';


void main() {
  runApp(const InsulinCalcApp());
}

class InsulinCalcApp extends StatelessWidget{
  const InsulinCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const CalculatorHomePage(),
      theme: ThemeData(
        fontFamily: 'Coolvetica',
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      routes: {
        '/calc' : (context) => const CalcStepOne(),
        '/disclaimer' : (context) => const Disclaimer(),
      },
    );
  }

}
