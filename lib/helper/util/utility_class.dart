import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studentinfo/app/ui/signin/signin.dart';
import 'package:studentinfo/helper/util/shared_preference.dart';
import '../constants.dart';

class Utility {
  Utility._privateConstructor();

  static final Utility _instance = Utility._privateConstructor();

  static Utility get instance {
    return _instance;
  }

  popClass(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }

  showErrorToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showSuccessToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void  innerLoader(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kDeepBlack,
          content: Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Please wait...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kTextColor1,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kTextColor1)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kDeepBlack,
          content: Text("Are you sure?",
              style: TextStyle(
                  color: kTextColor2,
                  fontFamily: "roboto_bold",
                  fontWeight: FontWeight.w400,
                  fontSize: 16)),
          actions: <Widget>[
            FlatButton(
              child: new Text("No",
                  style: TextStyle(
                      color: kTextColor2,
                      fontFamily: "roboto_bold",
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text("Yes",
                  style: TextStyle(
                      color: kTextColor2,
                      fontFamily: "roboto_bold",
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onPressed: () async{
                Navigator.of(context).pop();
                await SharedPrefUtil.writeString(PreferenceKey.USER_EMAIL,
                    "");
                await SharedPrefUtil.writeBoolean(
                    PreferenceKey.IS_LOGGED_IN, false);
                await SharedPrefUtil.writeString(
                    PreferenceKey.ACCESS_TOKEN,
                    "");
                await SharedPrefUtil.writeString(PreferenceKey.IMAGE_PATH, "");
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignInActivity(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

}
