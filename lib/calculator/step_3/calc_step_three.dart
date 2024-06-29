import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:insulin_wizard/calculator/calc_final_page.dart';
import '../step_2/text_box_item.dart';
import 'info_card_item.dart';

class CalcStepThree extends StatefulWidget {
  final double tdid, totalCarbsStep3;
  const CalcStepThree(
      {super.key, required this.tdid, required this.totalCarbsStep3});

  @override
  _CalcStepThreeState createState() => _CalcStepThreeState();
}

class _CalcStepThreeState extends State<CalcStepThree> {
  String currentBG = "", targetBG = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 215, 206, 178),
      appBar: AppBar(
        title: const Text("Step 3 - Glucose Information"),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () {
            double currentBGValue = double.tryParse(currentBG) ?? 0;
            double targetBGValue = double.tryParse(targetBG) ?? 0;

            if (currentBG.isNotEmpty &&
                targetBG.isNotEmpty &&
                currentBGValue > targetBGValue &&
                currentBGValue >= 0 &&
                targetBGValue >= 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalcFinalPage(
                    finalCarbRatio: 500 / widget.tdid,
                    finalTDID: widget.tdid,
                    finalTotalCarbs: widget.totalCarbsStep3,
                    finalCurrentBG: currentBGValue,
                    finalTargetBG: targetBGValue,
                    finalISF: 1800 / widget.tdid,
                  ),
                ),
              );
            } else if (currentBGValue < 0 || targetBGValue < 0) {
              Flushbar(
                title: "Blood glucose values cannot be negative.",
                message:
                    "Please enter valid non-negative values for current and target blood glucose.",
                duration: const Duration(seconds: 5),
              ).show(context);
            } else if (currentBGValue <= targetBGValue) {
              Flushbar(
                title:
                    "Your current blood glucose is lower than or equal to your target blood glucose.",
                message:
                    "The calculator will not work properly, please re-input your blood glucose levels.",
                duration: const Duration(seconds: 5),
              ).show(context);
            } else if (currentBG.isEmpty) {
              Flushbar(
                title: "Please enter a valid current blood glucose value.",
                message: "Go back to Step 1 to configure your foods.",
                duration: const Duration(seconds: 3),
              ).show(context);
            } else {
              Flushbar(
                title: "Please enter a valid target blood glucose value.",
                message: "Go back to Step 1 to configure your foods.",
                duration: const Duration(seconds: 3),
              ).show(context);
            }
          },
          child: const Text(
            "Continue",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "So far, you have inputted:",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Text(
                "Total Carbs: ${widget.totalCarbsStep3.toString()}g\nTDID: ${widget.tdid.toString()} units",
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 30,
                ),
              ),
              const Divider(),
              const Text(
                "Glucose Information",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 10),
              InputBox(
                txt: "Current Blood Glucose",
                icon: Icons.access_alarms_outlined,
                acronym: "",
                input: (value) {
                  setState(() {
                    currentBG = value;
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              InputBox(
                txt: "Target Blood Glucose",
                icon: Icons.track_changes_outlined,
                acronym: "",
                input: (value) {
                  setState(() {
                    targetBG = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: InfoCard(
                      title: "ISF",
                      infoText: "skibidi",
                      value: (1800 / widget.tdid).toStringAsFixed(2),
                      icon: Icons.thermostat_outlined,
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: InfoCard(
                      title: "Carb Ratio",
                      infoText: "skibidi",
                      value: (500 / widget.tdid).toStringAsFixed(2),
                      icon: Icons.restaurant_outlined,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
