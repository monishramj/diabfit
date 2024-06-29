// ignore_for_file: non_constant_identifier_names

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'calc_step_one.dart';

class FoodRequestStepTwoPopup extends StatefulWidget {
  final FoodItem foodItem;

  const FoodRequestStepTwoPopup({Key? key, required this.foodItem})
      : super(key: key);

  @override
  State<FoodRequestStepTwoPopup> createState() =>
      _FoodRequestStepTwoPopupState();
}

class _FoodRequestStepTwoPopupState extends State<FoodRequestStepTwoPopup> {
  String selectedMeasureType = "---"; // Selected serving size
  String selectedMeasureURI = ""; //!! UNUSED AT THE MOMENT
  int selectedQuantity = 0; // Quantity
  Map<String, dynamic>? nutrientInfo;
  List measurements = [];
  late TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final String _appId = '99dcb1d4';
  final String _appKey = 'f026f3107eb169d48758f7458761f5f2';

  Future<void> fetchNutrientInfo() async {
    //selectedMeasureURI = createServings(widget.foodItem)[selectedMeasureType]!;
    print(selectedMeasureURI);

    final url =
        'https://api.edamam.com/api/food-database/v2/nutrients?app_id=$_appId&app_key=$_appKey';

    final body = {
      'ingredients': [
        {
          'quantity': selectedQuantity,
          'measureURI': selectedMeasureURI, //set this to the actual thing
          'foodId': widget.foodItem.foodID,
        }
      ]
    };

    final response = await http.post(Uri.parse(url), body: json.encode(body));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        nutrientInfo = data;
        print("It works!!");
      });
    } else {
      throw Exception(
          ' THERES AN ERROR RANNOOOO O Error ${response.statusCode}');
    }
  }

  // creates list of items for the dropdownbutton in card
  Map<String, double> _createServings(FoodItem food) {
    //swtich it to a MAP
    Map<String, double> output = {"---": 1};
    for (int i = 0; i < food.measures.length - 1; i++) {
      output[food.measures[i]["label"]] = food.measures[i]["weight"];
    }
    return output;
  }

  void calculateNutrients() {
    double weight =
        _createServings(widget.foodItem)[selectedMeasureType]! / 100;

double? ENERC_KCAL =
    widget.foodItem.nutritionBasicInfo["ENERC_KCAL"]?.toDouble() ?? 0;
double? PROCNT = widget.foodItem.nutritionBasicInfo["PROCNT"]?.toDouble() ?? 0;
double? FAT = widget.foodItem.nutritionBasicInfo["FAT"]?.toDouble() ?? 0;
double? CHOCDF = widget.foodItem.nutritionBasicInfo["CHOCDF"]?.toDouble() ?? 0;
double? FIBTG = widget.foodItem.nutritionBasicInfo["FIBTG"]?.toDouble() ?? 0;

    widget.foodItem.totalKCal =
        double.parse((weight * ENERC_KCAL! * selectedQuantity).toStringAsFixed(2));
    widget.foodItem.totalProtein =
        double.parse((weight * PROCNT! * selectedQuantity).toStringAsFixed(2));
    widget.foodItem.totalFat = double.parse((weight * FAT! * selectedQuantity).toStringAsFixed(2));
    widget.foodItem.totalCarbs =
        double.parse((weight * CHOCDF! * selectedQuantity).toStringAsFixed(2));
    widget.foodItem.totalFiber =
        double.parse((weight * FIBTG! * selectedQuantity).toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.foodItem.food}'),
      content: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Serving size:"),
              DropdownButton<String>(
                  value: selectedMeasureType.isEmpty
                      ? widget.foodItem.measures[0]["label"]
                      : selectedMeasureType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMeasureType = newValue!;
                    });
                  },
                  items: _createServings(widget.foodItem).entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.key), 
                    );
                  }).toList()),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Quantity:"),
                SizedBox(
                  width: 40,
                  child: TextField(
                      enabled: true,
                      keyboardType:
                          const TextInputType.numberWithOptions(signed: false),
                      controller: controller,
                      onChanged: (String value) {
                        setState(() {
                          selectedQuantity = int.tryParse(value) ?? 0;
                        });
                      }),
                )
              ]),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
        if (selectedMeasureType == "---" &&
                  selectedQuantity == 0) {
                Flushbar(
                  title: "Not all fields inputted.",
                  message: "Please enter a serving size and quantity.",
                  duration: const Duration(seconds: 3),
                ).show(context);
              } else if (selectedMeasureType == "---") {
                Flushbar(
                  title: "Not all fields inputted.",
                  message: "Please enter a serving size.",
                  duration: const Duration(seconds: 3),
                ).show(context);
              } else if (selectedQuantity == 0) {
                Flushbar(
                  title: "Not all fields inputted.",
                  message: "Please enter a quantity.",
                  duration: const Duration(seconds: 3),
                ).show(context);
              }
              else {
                fetchNutrientInfo();
                widget.foodItem.servingsamt = (selectedQuantity);
                widget.foodItem.measureType = (selectedMeasureType);
                calculateNutrients();
                Navigator.of(context).pop(widget.foodItem);
              }
            },
            child: const Text("Submit"))
      ],
    );
  }
}
