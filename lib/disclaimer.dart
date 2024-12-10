import 'package:flutter/material.dart';
//11:13:05

class Disclaimer extends StatefulWidget {
  const Disclaimer({super.key});

  @override
  State<Disclaimer> createState() => DisclaimerState();
}

class DisclaimerState extends State<Disclaimer> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 215, 206, 178),
      appBar: AppBar(
        title: const Text("Disclaimer"),
        centerTitle: true,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
Text(
  '''
General Information:

The DiabFit app is designed to assist users in estimating insulin doses based on nutritional information and general knowledge. This app is not created by medical professionals and is intended for educational purposes only. While we strive to provide useful and accurate information, DiabFit should not be relied upon as a sole source for managing diabetes or making medical decisions.

Accuracy and Reliability:

The calculations provided by the DiabFit app are based on nutritional data obtained from third-party sources and generalized assumptions. These calculations are not 100% accurate and may not account for individual variations, such as personal health conditions, specific insulin sensitivity, or other factors that could affect insulin requirements.

Medical Advice and Emergency Situations:

The DiabFit app is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified healthcare providers with any questions you may have regarding your diabetes management. Do not disregard professional medical advice or delay seeking it because of information provided by this app.

In the event of a medical emergency, call your doctor or emergency services immediately. The DiabFit app is not equipped to handle or respond to emergency situations.

User Responsibility:

By using the DiabFit app, you acknowledge and agree that:

1. You are solely responsible for verifying the accuracy and applicability of any information provided by the app.
2. You will consult with your healthcare provider before making any changes to your insulin regimen or diabetes management plan.
3. You understand that the app is developed by non-professional developers and may contain errors or inaccuracies.

Liability:

The creator of the DiabFit app, along with any associates, partners, or affiliates, assumes no responsibility or liability for any damages, losses, or injuries arising from the use of this app. Use of the app is at your own risk.

Updates and Changes:

The DiabFit app may be updated periodically to improve functionality and accuracy. However, there is no guarantee that the app will be updated regularly or that any identified issues will be promptly addressed.

Contact Information:

If you have any questions, concerns, or feedback regarding the DiabFit app, please contact us at diabfitofficial@gmail.com.

Acknowledgment:

By using the DiabFit app, you acknowledge that you have read, understood, and agreed to the terms and conditions outlined in this disclaimer. If you do not agree with these terms, please do not use the app.
  ''',
),

Text("© 2024 DiabFit"),

                
              ],
              
            ),
          ),
        ),
      ),
    );
  }

}
