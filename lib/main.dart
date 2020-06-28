import 'package:flutter/material.dart';
import 'package:studentinfo/app/ui/splash/splash_page.dart';

import 'helper/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Muli',
        textSelectionHandleColor: Colors.transparent,
        cursorColor: kOrange,
      ),
      home: SplashActivity(),
    );
  }
}
