import 'package:flutter/material.dart';
import 'package:flutter_onboarding/ui/screens/signin_page.dart';

import 'ui/onboarding_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Signin Page',
      home: OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
