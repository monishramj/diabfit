

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
//FIX THESE LATER!!

import 'package:flutter/material.dart';
//11:13:05

class CalculatorHomePage extends StatefulWidget {
  const CalculatorHomePage({super.key});

  @override
  State<CalculatorHomePage> createState() => CalculatorHomePageState();
}

class CalculatorHomePageState extends State<CalculatorHomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 215, 206, 178),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Recommended Amount \n of Glucose:",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                height: 0,
              ),
              textAlign: TextAlign.center,
            ),

            Text("0", 
              style: TextStyle( // change color based on amount required (red, green, yellow)
                fontSize: 200,
                height: 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 70),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: Icon(Icons.accessibility_new_rounded),
                  labelText: "Enter weight in pounds.",
                  focusedBorder: UnderlineInputBorder()               
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 70),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: Icon(Icons.food_bank_rounded),
                  labelText: "Enter grams of carbs.",
                  focusedBorder: UnderlineInputBorder()               
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 70),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: Icon(Icons.punch_clock_rounded),
                  labelText: "Enter current blood glucose.",
                  focusedBorder: UnderlineInputBorder()               
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 70),
              child: TextField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: Icon(Icons.track_changes_outlined),
                  labelText: "Enter target blood glucose.",
                  focusedBorder: UnderlineInputBorder()               
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
