import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _isBottom = true;
      });
    }
  }

  Future<void> _acceptDisclaimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('acceptedDisclaimer', true);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disclaimer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: const Text(
                  '''
Summary:

This application, DiabFit, is not created by medical professionals. Although the calculations are based on research, they are not guaranteed to be 100% accurate. Users should always consult medical experts and treat the information from this app with caution.

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

If you have any questions, concerns, or feedback regarding the DiabFit app, please contact us at INSERT EMAIL HERE LATER.

Acknowledgment:

By using the DiabFit app, you acknowledge that you have read, understood, and agreed to the terms and conditions outlined in this disclaimer. If you do not agree with these terms, please do not use the app.
  ''',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isBottom ? _acceptDisclaimer : null,
              child: Text('I Accept'),
            ),
          ],
        ),
      ),
    );
  }
}
