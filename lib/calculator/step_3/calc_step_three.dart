import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:insulin_wizard/calculator/calc_final_page.dart';
import '../step_2/text_box_item.dart';
import 'info_card_item.dart';

class CalcStepThree extends StatefulWidget {
  final double tdid, totalCarbsStep3;
  const CalcStepThree({
    Key? key,
    required this.tdid,
    required this.totalCarbsStep3,
  }) : super(key: key);

  @override
  _CalcStepThreeState createState() => _CalcStepThreeState();
}

class _CalcStepThreeState extends State<CalcStepThree> {
  String currentBG = "", targetBG = "";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Step 3 - Glucose Information"),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
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
                    finalISF: 1500 / widget.tdid,
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
            "Calculate",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
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
                "Total Carbs: ${widget.totalCarbsStep3.toStringAsFixed(2)}g\nTDID: ${widget.tdid.toStringAsFixed(2)} units",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: screenWidth * 0.06,
                ),
              ),
              const Divider(),
              Text(
                "Glucose Information",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: screenWidth * 0.08,
                ),
              ),
              const SizedBox(height: 10),
              InputBox(
                txt: "Current Blood Glucose",
                icon: Icons.access_alarms_outlined,
                acronym: "mg/dL",
                desc: "This is the level of sugar (glucose) in your blood currently, after your meal. It should be higher than your target blood glucose.",
                input: (value) {
                  setState(() {
                    currentBG = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              InputBox(
                txt: "Target Blood Glucose",
                icon: Icons.track_changes_outlined,
                acronym: "mg/dL",
                desc: "This is the ideal blood sugar level you aim for. It’s set based on your doctor’s recommendations to keep you healthy.",
                input: (value) {
                  setState(() {
                    targetBG = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
                    child: InfoCard(
                      title: "ISF",
                      infoText: "ISF, or your Insulin Sensitivity Factor, tells you how much 1 unit of insulin will affect your blood sugar. For example, if your ISF is 50, 1 unit of insulin will reduce your blood sugar by 50 mg/dL. This can be determied by your total daily insulin dose.",
                      value: (1800 / widget.tdid).toStringAsFixed(2),
                      icon: Icons.thermostat_outlined,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.2,
                    child: InfoCard(
                      title: "Carb Ratio",
                      infoText: "This indicates how many grams of carbohydrates 1 unit of insulin will cover. For instance, if your ratio is 10:1, 1 unit of insulin is needed for every 10 grams of carbs you eat.",
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
