import 'package:flutter/material.dart';
import 'package:insulin_wizard/calculator/step_1/calc_step_one.dart';

class FoodItemPage extends StatelessWidget {
  final FoodItem foodItem;

  const FoodItemPage({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(foodItem.food),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Hero(
                      tag: 'foodItem_${foodItem.food}',
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 0, 0, 0),
                              Color.fromARGB(202, 0, 0, 0),
                              Color.fromARGB(116, 0, 0, 0),
                              Color.fromARGB(61, 0, 0, 0),
                              Colors.transparent,
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(foodItem.pic),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 30,
                        child: Text(
                          foodItem.food,
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.black,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "${foodItem.servingsamt ?? 0} ${foodItem.measureType ?? ""}(s)",
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            const Divider(thickness: 1, indent: 20, endIndent: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNutritionInfoItem(
                      'Total Calories', foodItem.totalKCal?.toStringAsFixed(2) ?? "0", "kcal"),
                  _buildNutritionInfoItem(
                      'Total Protein', foodItem.totalProtein?.toStringAsFixed(2) ?? "0", "g"),
                  _buildNutritionInfoItem(
                      'Total Carbs', foodItem.totalCarbs?.toStringAsFixed(2) ?? "0", "g"),
                  _buildNutritionInfoItem(
                      'Total Fat', foodItem.totalFat?.toStringAsFixed(2) ?? "0", "g"),
                  _buildNutritionInfoItem(
                      'Total Fiber', foodItem.totalFiber?.toStringAsFixed(2) ?? "0", "g"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionInfoItem(String title, String value, String units) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '$value $units',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}