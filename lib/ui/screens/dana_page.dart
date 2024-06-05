import 'package:flutter/material.dart';
import 'package:flutter_onboarding/constants.dart';
import 'package:flutter_onboarding/ui/root_page.dart';
import 'home_page.dart';
import 'package:page_transition/page_transition.dart';

class DanaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran Dana'),
        backgroundColor: Constants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Silahkan Melakukan Pembayaran Dana Ke No 082273184371 AN Azhari (Dana)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: RootPage(),
                  ),
                );
              },
              child: Text('Home'),
              style: ElevatedButton.styleFrom(
                primary: Constants.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
