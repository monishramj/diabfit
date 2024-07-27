import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:insulin_wizard/calculator/step_3/calc_step_three.dart';

import '../step_1/calc_step_one.dart';
import '../step_1/food_item_page.dart';
import 'text_box_item.dart';

class CalcStepTwo extends StatefulWidget {
  final List<FoodItem> selectedFoods;
  final Function(FoodItem) removeSelectedFood;
  final double trackedCarbs;
  final bool isManualInput;

  const CalcStepTwo({
    Key? key,
    required this.selectedFoods,
    required this.removeSelectedFood,
    required this.trackedCarbs,
    required this.isManualInput,
  }) : super(key: key);

  @override
  State<CalcStepTwo> createState() => CalcStepTwoState();
}

class CalcStepTwoState extends State<CalcStepTwo> {
  String defaultFoodIcon =
      'https://cdn0.iconfinder.com/data/icons/basic-11/97/16-512.png';

  String totalCalories = "";
  String tdid = "";

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Step 2 - Medicinal Info"),
        centerTitle: true,
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: ElevatedButton(
          onPressed: () {
            bool hasSelectedFoods = widget.selectedFoods.isNotEmpty;
            double? parsedTDID = double.tryParse(tdid);
            bool isValidTdid = parsedTDID != null && parsedTDID > 0;
            if ((hasSelectedFoods || widget.isManualInput) && isValidTdid) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalcStepThree(
                    tdid: double.tryParse(tdid) ?? 0,
                    totalCarbsStep3: widget.isManualInput ? widget.trackedCarbs : calculateTotalCarbs(widget.selectedFoods),
                  ),
                ),
              );
            } else if (widget.selectedFoods.isEmpty && !widget.isManualInput) {
              Flushbar(
                title: "You cannot have an empty list of foods.",
                message: "Go back to Step 1 to configure your foods.",
                duration: const Duration(seconds: 3),
              ).show(context);
            } else if (parsedTDID != null && parsedTDID <= 0) {
              Flushbar(
                title: "TDID value cannot be negative or zero.",
                message: "Please enter a valid positive TDID value.",
                duration: const Duration(seconds: 3),
              ).show(context);
            } else {
              Flushbar(
                title: "Please enter a valid TDID value.",
                message: "Press the Info(i) icon to learn more.",
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
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.isManualInput) ...[
                Text(
                  "Manual Carb Intake",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: screenWidth * 0.08,
                  ),
                ),
                Text(
                  "${widget.trackedCarbs}g",
                  style: TextStyle(
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ] else ...[
                Text(
                  "Selected Foods",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: screenWidth * 0.08,
                  ),
                ),
                Card(
                  elevation: 15,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: Card(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                screenWidth * 0.03,
                                screenWidth * 0.03,
                                screenWidth * 0.03,
                                0),
                            height: isPortrait ? screenHeight * 0.4 : screenHeight * 0.5,
                            child: widget.selectedFoods.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(screenWidth * 0.02),
                                      child: Opacity(
                                        opacity: .3,
                                        child: Text(
                                          "This list is empty. Go back to Step 1 and configure your foods.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.05,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: widget.selectedFoods.length,
                                    itemBuilder: (context, index) {
                                      return ClipRRect(
                                        child: Dismissible(
                                          key: Key(
                                              "foodItem_${widget.selectedFoods[index].food}"),
                                          onDismissed: (direction) {
                                            Flushbar(
                                              title: "Item Removed",
                                              message:
                                                  "The ${widget.selectedFoods[index].food} has been removed.",
                                              duration:
                                                  const Duration(seconds: 2),
                                            ).show(context);
                                            setState(() {
                                              widget.removeSelectedFood(
                                                  widget.selectedFoods[index]);
                                            });

                                            if (widget.selectedFoods.isEmpty) {
                                              Flushbar(
                                                title:
                                                    "You cannot have an empty list of foods.",
                                                message:
                                                    "Go back to Step 1 to configure your foods.",
                                                duration:
                                                    const Duration(seconds: 3),
                                              ).show(context);
                                            }
                                          },
                                          direction: DismissDirection.startToEnd,
                                          movementDuration:
                                              const Duration(milliseconds: 500),
                                          background: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.all(screenWidth * 0.03),
                                              child: Icon(
                                                Icons.delete,
                                                color: Theme.of(context).canvasColor,
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                              leading: Hero(
                                                tag:
                                                    'foodItem_${widget.selectedFoods[index].food}',
                                                child: ClipOval(
                                                  child: Image.network(
                                                    widget.selectedFoods[index]
                                                        .getPic(),
                                                    errorBuilder: (context, error,
                                                        stackTrace) {
                                                      return Image.network(
                                                          defaultFoodIcon);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                widget.selectedFoods[index]
                                                    .getFood(),
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.04,
                                                ),
                                              ),
                                              subtitle: Text(
                                                "${(widget.selectedFoods[index].totalKCal)} kCal - ${widget.selectedFoods[index].servingsamt} ${widget.selectedFoods[index].measureType}(s)",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontSize: screenWidth * 0.035,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          FoodItemPage(
                                                            foodItem: widget
                                                                    .selectedFoods[
                                                                index],
                                                          )),
                                                );
                                              }),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Text(
                        "Total Carbohydrates",
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "${calculateTotalCarbs(widget.selectedFoods).toStringAsFixed(2)}g",
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Divider(),
              Text(
                "Medicinal Info",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: screenWidth * 0.08,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InputBox(
                    txt: "Total Daily Insulin Dose",
                    acronym: "TDID",
                    icon: Icons.speed,
                    input: (value) {
                      setState(() {
                        tdid = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTotalCarbs(List<FoodItem> arr) {
    double output = 0;
    for (FoodItem food in arr) {
      output += food.totalCarbs!;
    }
    return output;
  }

  double calculateTotalCalories(List<FoodItem> arr) {
    double output = 0;
    for (FoodItem food in arr) {
      output += food.totalKCal!;
    }
    return output;
  }
}
