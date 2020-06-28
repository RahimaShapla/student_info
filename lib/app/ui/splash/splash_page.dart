import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentinfo/app/ui/profile/my_profile.dart';
import 'package:studentinfo/app/ui/signin/signin.dart';
import 'package:studentinfo/helper/constants.dart';
import 'package:studentinfo/helper/util/shared_preference.dart';

class SplashActivity extends StatefulWidget {
  @override
  _SplashActivityState createState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));
    return _SplashActivityState();
  }
}

class _SplashActivityState extends State<SplashActivity> {
  void getNextWidget() async {
    if (await SharedPrefUtil.getBoolean(PreferenceKey.IS_LOGGED_IN)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileActivity(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInActivity(),
        ),
      );
    }
  }

  @override
  void initState() {
    Timer(
      Duration(seconds: 2),
      getNextWidget,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.5, 1],
            colors: [kDeepBlack, kLightBlack],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 220,
              width: 220,
              child: Image(
                image: AssetImage("assets/images/ic_logo.png"),
              ),
            ),
            Text(
              "STUDENT INFO",
              style: TextStyle(
                  color: kOrange, fontSize: 30, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
