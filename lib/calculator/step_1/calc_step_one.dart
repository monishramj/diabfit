import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import '../step_2/calc_step_two.dart';
import 'food_serving_request.dart';
import 'package:insulin_wizard/calculator/step_1/food_item_page.dart';

//*GOALS:
//! Add functionality for also tracking their own calories!

class CalcStepOne extends StatefulWidget {
  const CalcStepOne({Key? key}) : super(key: key);

  @override
  State<CalcStepOne> createState() => _CalcStepOneState();
}

class FoodItem {
  String food, pic, foodID;
  List measures;
  Map<String, dynamic> nutritionBasicInfo;
  int? servingsamt;
  double? totalKCal, totalProtein, totalFat, totalCarbs, totalFiber;
  String? measureType;

  FoodItem(
      this.food, this.foodID, this.pic, this.measures, this.nutritionBasicInfo);

  String getFood() {
    return food;
  }

  String getPic() {
    return pic;
  }

  List getMeasures() {
    return measures;
  }
}

class _CalcStepOneState extends State<CalcStepOne> {
  final TextEditingController _searchController = TextEditingController();
  List<FoodItem> suggestedFoods = [];
  List<FoodItem> selected = [];
  String defaultFoodIcon =
      'https://cdn0.iconfinder.com/data/icons/basic-11/97/16-512.png';
  bool isManualInput = false;
  double trackedCarbs = 0.0;
  bool _isLoading = false; // Loading state

  Future<void> searchFoods(String query) async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final String appId = dotenv.env['APP_ID'] ?? 'aaa';
    final String appKey = dotenv.env['APP_KEY'] ?? 'aaaa';

    try {
      final url =
          'https://api.edamam.com/api/food-database/v2/parser?ingr=$query&app_id=$appId&app_key=$appKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200 && query.isNotEmpty) {
        final data = json.decode(response.body);
        List<FoodItem> foods = [];
        for (var food in data['hints']) {
          foods.add(FoodItem(
              food['food']['label'],
              food['food']['foodId'],
              food['food']['image'] ?? defaultFoodIcon,
              food['measures'],
              food['food']['nutrients']));
        }
        setState(() {
          suggestedFoods = foods;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        throw Exception(
            'Failed to load foods. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Flushbar(
        title: "Error",
        message: "Failed to load foods. Please try again.",
        duration: const Duration(seconds: 3),
      ).show(context);
      //print('Error: $e');
    }
  }

  void addSelectedFood(FoodItem food) {
    setState(() {
      selected.add(food);
    });
  }

  void removeSelectedFood(FoodItem food) {
    setState(() {
      selected.remove(food);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    final double height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Step 1 - Food Track",
          style: TextStyle(fontSize: width * 0.05), // Responsive text size
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(width * 0.02), // Responsive padding
        child: ElevatedButton(
          onPressed: () {
            if (selected.isNotEmpty || trackedCarbs > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalcStepTwo(
                    trackedCarbs: trackedCarbs,
                    selectedFoods: selected,
                    removeSelectedFood: removeSelectedFood,
                    isManualInput: isManualInput,
                  ),
                ),
              );
            } else {
              if (isManualInput) {
                Flushbar(
                  title: "Carb Intake value cannot be negative or zero.",
                  message: "Please enter a valid positive Carb Intake value.",
                  duration: const Duration(seconds: 3),
                ).show(context);
              } else {
                Flushbar(
                  title: "Your list of foods is empty.",
                  message:
                      "Use the searchbar to find the foods you want to track.",
                  duration: const Duration(seconds: 3),
                ).show(context);
              }
            }
          },
          child: Text(
            "Continue",
            style: TextStyle(fontSize: width * 0.05), // Responsive text size
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(width * 0.05), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Food Search",
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: width * 0.1, // Responsive text size
                  ),
                ),
                IconButton(
                  hoverColor: Theme.of(context).highlightColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Carb Intake", // Responsive text size
                          ),
                          content: const Text(
                            "To calculate your insulin dose, we require your carb intake for your meal. Use the Food Search to add foods to your list, or use Manual Input to track your own carb intake. ** DOUBLE TAP TO REMOVE A FOOD FROM THE FOOD SEARCH** .", // Responsive text size
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "OK",
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.info_outline_rounded,
                    size: width * 0.07,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Manual Input",
                      style: TextStyle(fontSize: width * 0.05),
                    ),
                    SizedBox(width: 10,),
                    Switch(
                      value: isManualInput,
                      onChanged: (value) {
                        setState(() {
                          isManualInput = value;
                        });
                      },
                    ),
                  ],
                ),
                if (!isManualInput) ...[
                  SizedBox(
                      height: 30,
                      child: Image.asset('assets/images/Edamam_Badge.png'))
                ]
              ],
            ),
            if (isManualInput) ...[
              Container(
                padding: EdgeInsets.all(width * 0.02), // Responsive padding
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04), // Responsive padding
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Carb Intake (g)",
                              softWrap: true,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: width * 0.05, // Responsive text size
                              ),
                            ),
                          ],
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            icon: Icon(Icons.add_circle_outline,
                                size: width * 0.07), // Responsive icon size
                            hintText: "Enter your carb intake...",
                          ),
                          onChanged: (value) {
                            trackedCarbs = double.tryParse(value) ?? 0.0;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search for foods...',
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          searchFoods(value);
                        } else {
                          setState(() {
                            suggestedFoods = [];
                          });
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: width * 0.07,
                    ),
                    onPressed: () {
                      final query = _searchController.text;
                      if (query.isNotEmpty) {
                        searchFoods(query);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: width * 0.02,
                  runSpacing: width * 0.01,
                  children: selected.map((food) {
                    return ClickableChip(
                      foodItem: food,
                      size: width * 0.35,
                      onDeleted: () {
                        setState(() {
                          selected.remove(food);
                        });
                      },
                      onSelected: () {},
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: height * 0.02), // Responsive spacing
              Expanded(
                child: SizedBox(
                  width: 80,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: width *
                                0.01, // Responsive progress indicator width
                          ),
                        )
                      : ListView.builder(
                          itemCount: suggestedFoods.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: ClipOval(
                                child: Image.network(
                                  suggestedFoods[index].getPic(),
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                        defaultFoodIcon); // use default image in case of error
                                  },
                                ),
                              ),
                              title: Text(
                                suggestedFoods[index].getFood(),
                                style: TextStyle(
                                    fontSize:
                                        width * 0.04), // Responsive text size
                              ),
                              subtitle: Text(
                                "${double.parse(suggestedFoods[index].nutritionBasicInfo["ENERC_KCAL"].toStringAsFixed(2))} kCal - 1 Serving",
                                style: TextStyle(
                                    fontSize:
                                        width * 0.035), // Responsive text size
                              ),
                              onTap: () async {
                                final selectedFood = await showDialog<FoodItem>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return FoodRequestStepTwoPopup(
                                        foodItem: suggestedFoods[index]);
                                  },
                                  barrierDismissible: true,
                                );
                                addSelectedFood(selectedFood!);
                                _searchController.clear();
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

//class for building the chip that is displayed on the row when a food item is selected from the search list
class ClickableChip extends StatefulWidget {
  final FoodItem foodItem;
  final double size;
  final Function() onDeleted, onSelected;

  const ClickableChip(
      {super.key,
      required this.onDeleted,
      required this.onSelected,
      required this.foodItem,
      required this.size});

  @override
  State<ClickableChip> createState() => _ClickableChipState();
}

//class for building the chip that is displayed on the row when a food item is selected from the search list
class _ClickableChipState extends State<ClickableChip> {
  bool clickCheck = false;
  String defaultFoodIcon =
      "https://cdn0.iconfinder.com/data/icons/basic-11/97/16-512.png";
  @override
  Widget build(BuildContext context) {
    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          clickCheck = !clickCheck;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoodItemPage(
                foodItem: widget.foodItem,
              ),
            ),
          );
        });
      },
      onDoubleTap: () {
        setState(() {
          widget.onDeleted();
        });
      },
      child: Hero(
        tag: 'foodItem_${widget.foodItem.food}',
        child: Card(
          elevation: 5,
          child: Container(
            width: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                  width * 0.02), // Responsive border radius
            ),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color.fromARGB(116, 0, 0, 0),
                        Color.fromARGB(255, 0, 0, 0),
                        Colors.transparent,
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    widget.foodItem.pic,
                    scale: 1,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                            strokeWidth: width *
                                0.01, // Responsive progress indicator width
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Image.network(defaultFoodIcon, scale: 1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(width * 0.02), // Responsive padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.foodItem.food,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: widget.size * 0.16, // Responsive text size
                          shadows: [
                            Shadow(
                              blurRadius: 30.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${widget.foodItem.totalKCal} kCal",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: widget.size * 0.15, // Responsive text size
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${widget.foodItem.servingsamt} ${widget.foodItem.measureType}(s)",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: widget.size * 0.12, // Responsive text size
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
