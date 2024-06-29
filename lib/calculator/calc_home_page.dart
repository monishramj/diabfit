


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
            const Text("DiabFit",
              style: TextStyle(
                fontSize: 80,
              ),
            ),

            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/calc');
                }, 
                child: const Text("Start", 
                  style: TextStyle(
                    fontSize: 30
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/disclaimer');
                }, 
                child: const Text("Disclaimer", 
                  style: TextStyle(
                    fontSize: 30
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
        
    );
  }

}
