import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class CalcFinalPage extends StatefulWidget {
  final double finalTDID,
      finalTotalCarbs,
      finalCurrentBG,
      finalTargetBG,
      finalCarbRatio,
      finalISF;
  const CalcFinalPage(
      {super.key,
      required this.finalTDID,
      required this.finalTotalCarbs,
      required this.finalCurrentBG,
      required this.finalTargetBG,
      required this.finalCarbRatio,
      required this.finalISF});

  @override
  State<CalcFinalPage> createState() => _CalcFinalPageState();
}

class _CalcFinalPageState extends State<CalcFinalPage> {
  double mealTimeDose = 0;
  bool showDose = false;
  late ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 3),
  );

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        showDose = true;
      });
      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mealTimeDose = (widget.finalTotalCarbs / widget.finalCarbRatio) +
        ((widget.finalCurrentBG - widget.finalTargetBG) / widget.finalISF);
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
          child: const Text(
            "Return",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Recommended\nTotal Mealtime Insulin Dose",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    height: 0,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  height: showDose ? 178 : 0,
                  child: Text(
                    mealTimeDose.toStringAsFixed(1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 200,
                      height: .97,
                      letterSpacing: .6,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConfettiWidget(
                      blastDirectionality: BlastDirectionality.explosive,
                      confettiController: _confettiController,
                      blastDirection: -pi / 2,
                      maxBlastForce: 30,
                      minBlastForce: 10,
                      emissionFrequency: .8,
                      numberOfParticles: 5,
                      gravity: 0.2,
                      shouldLoop: false,
                    ),
                  ],
                ),
                const Text(
                  "units",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
                    height: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
