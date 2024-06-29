import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:insulin_wizard/calculator/step_1/food_item_page.dart';
import 'dart:convert';
import '../step_2/calc_step_two.dart';
import 'food_serving_request.dart';

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
  //?? Can implement more for all nutritional info

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

  // void setServings(int servings) {servingsamt = servings;}
  // void setKCal(int calories) {kcal = calories;}
  // void setMeasureType(String type) {measureType = type;}
}

class _CalcStepOneState extends State<CalcStepOne> {
  final TextEditingController _searchController = TextEditingController();
  double trackedCarbs = 0;
  List<FoodItem> suggestedFoods =
      []; //TODO: Create FoodItem object for later use
  List<FoodItem> selected = [];
  String defaultFoodIcon =
      'https://cdn0.iconfinder.com/data/icons/basic-11/97/16-512.png';
  //TODO : Create Properties File for assets https://www.digitalocean.com/community/tutorials/python-read-properties-file
  final String _appId = '99dcb1d4';
  final String _appKey = 'f026f3107eb169d48758f7458761f5f2';

  Future<void> searchFoods(String query) async {
    final url =
        'https://api.edamam.com/api/food-database/v2/parser?ingr=$query&app_id=$_appId&app_key=$_appKey';
    //https://api.edamam.com/api/food-database/v2/parser?ingr=butter&app_id=99dcb1d4&app_key=f026f3107eb169d48758f7458761f5f2

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 && query != "") {
      final data = json.decode(response.body);
      List<FoodItem> foods = [];
      for (var food in data['hints']) {
        foods.add(FoodItem(
            food['food']['label'],
            food['food']['foodId'],
            food['food']['image'] ?? defaultFoodIcon,
            food['measures'],
            food['food']['nutrients']));

        // foods.add(food['food']['label']);
        // if (food['food']['image'] != null) {
        //   foodPics.add(food['food']['image']);
        // }
        // else {
        //   foodPics.add(defaultFoodIcon);
        //   //! Create assets when working on front-end (assets folder); PROPERTIES FILE
        // }
      }
      setState(() {
        suggestedFoods = foods;
      });
    } else {
      throw Exception('Failed to load foods. Error 401');
      //TODO: implement visual
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Step 1 - Food Track"),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            if (selected.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalcStepTwo(
                      selectedFoods: selected, trackedCarbs: trackedCarbs,
                      removeSelectedFood: removeSelectedFood,
                      ),
                ),
              );
            } else {
              Flushbar(
                title: "Your list of foods is empty.",
                message:
                    "Use the searchbar to find the foods you want to track.",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Food Search",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 40,
              ),
            ),
            TextField(
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
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: selected.map((food) {
                  return ClickableChip(
                    foodItem: food,
                    size: 160,
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
            const SizedBox(height: 20),
            Expanded(
              child: SizedBox(
                width: 80,
                child: ListView.builder(
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
                      title: Text(suggestedFoods[index].getFood()),
                      subtitle: Text(
                          "${double.parse(suggestedFoods[index].nutritionBasicInfo["ENERC_KCAL"].toStringAsFixed(2))} kCal"),
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
                      },
                      // onTap: () {
                      //   addSelectedFood(suggestedFoods[index]);
                      //   _searchController.clear();
                      //   setState(() {
                      //     suggestedFoods = [];
                      //   });
                      // },
                    );
                  },
                ),
              ),
            ),

            /*const Text("Or Input Number Of Carbs (in grams) Here:"),
            TextField(
              onSubmitted: (value) => trackedCarbs,
            ),
            */
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

  @override
  Widget build(BuildContext context) {
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
              borderRadius: BorderRadius.circular(10),
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.foodItem.food,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: widget.size / 7,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${(widget.foodItem.totalKCal)} kCal",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: widget.size / 9,
                        ),
                      ),
                      Text(
                        "${widget.foodItem.servingsamt} ${widget.foodItem.measureType}(s)",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: widget.size / 11,
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
