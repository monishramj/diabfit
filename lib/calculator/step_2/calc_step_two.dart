//import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:insulin_wizard/calculator/step_3/calc_step_three.dart';

import '../step_1/calc_step_one.dart';
import '../step_1/food_item_page.dart';
import 'text_box_item.dart';
//11:13:05

class CalcStepTwo extends StatefulWidget {
  final List<FoodItem> selectedFoods;
  final Function(FoodItem) removeSelectedFood;
  final double trackedCarbs; final bool isManualInput;
  const CalcStepTwo(
      {Key? key,
      required this.selectedFoods,
      required this.removeSelectedFood,
      required this.trackedCarbs, required this.isManualInput})
      : super(key: key);

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
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 215, 206, 178),
      appBar: AppBar(
        title: const Text("Step 2 - Medicinal Info"),
        centerTitle: true,
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
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
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.isManualInput)...[
                const Text(
                "Manual Carb Intake",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 40,
                ),
              ),
              Text(
                "${widget.trackedCarbs}g",
                style: const TextStyle(
                  fontSize: 30
                ),
              )
              ]
              else...[
                const Text(
                "Selected Foods",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 40,
                ),
              ),
              Card(
                elevation: 15,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          height: 200,
                          child: widget.selectedFoods.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Opacity(
                                      opacity: .3,
                                      child: Text(
                                        "This list is empty. Go back to Step 1 and configure your foods.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
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
                                            padding: const EdgeInsets.all(15.0),
                                            child: Icon(
                                              Icons.delete,
                                              color:
                                                  Theme.of(context).canvasColor,
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
                                                        defaultFoodIcon); // Use default image in case of error
                                                  },
                                                ),
                                              ),
                                            ),
                                            title: Text(
                                              widget.selectedFoods[index]
                                                  .getFood(),
                                              textAlign: TextAlign.left,
                                            ),
                                            subtitle: Text(
                                              "${(widget.selectedFoods[index].totalKCal)} kCal - ${widget.selectedFoods[index].servingsamt} ${widget.selectedFoods[index].measureType}(s)",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
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
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Total Carbohydrates",
                      style: TextStyle(
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                      textHeightBehavior: TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false),
                    ),
                    Text(
                      "${calculateTotalCarbs(widget.selectedFoods).toStringAsFixed(2)}g",
                      style: const TextStyle(
                        fontSize: 50,
                      ),
                      textAlign: TextAlign.center,
                      textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              ],
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const Text(
                "Medicinal Info",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 40,
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
                  )
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
