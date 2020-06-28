import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentinfo/app/ui/profile/my_profile.dart';
import 'package:studentinfo/app/ui/signin/signin_bloc.dart';
import 'package:studentinfo/helper/constants.dart';
import 'package:studentinfo/helper/network/api_response.dart';
import 'package:studentinfo/helper/util/shared_preference.dart';
import 'package:studentinfo/helper/util/utility_class.dart';

class SignInActivity extends StatefulWidget {
  @override
  _SignInActivityState createState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
    ));
    return _SignInActivityState();
  }
}

class _SignInActivityState extends State<SignInActivity> {
  SignInBloc _signInBloc;
  String deviceId;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDeepBlack1,
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          height: 400,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: kMediumBlack,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(
              Radius.circular(35.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "SIGN IN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: kTextColor1,
                      fontWeight: FontWeight.w900,
                      fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 50.0, 32.0, 2.0),
                child: Card(
                  color: kDeepBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0.0,
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: kHintTextColor1,
                        fontSize: 14.0,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0, 13, 13, 14),
                            child: Icon(
                              Icons.email,
                              color: kHintTextColor1,
                            ),
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          const EdgeInsets.fromLTRB(0.0, 13, 0, 0),
                          //hoverColor: kYellow,
                          hintStyle: TextStyle(
                            color: kLightBlack,
                          ),
                          hintText: "Email"),
                      controller: _emailController,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 2.0),
                child: Card(
                  color: kDeepBlack,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 0.0,
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: kHintTextColor1,
                        fontSize: 14.0,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 15, 10),
                            child: Icon(
                                Icons.lock,
                              color: kHintTextColor1,
                            ),
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                          const EdgeInsets.fromLTRB(0.0, 13, 0, 0),
                          //hoverColor: kYellow,
                          hintStyle: TextStyle(
                            color: kLightBlack,
                          ),
                          hintText: "Password"),
                      controller: _passwordController,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: (){
                 checkValidation();
                },
                child: Container(
                  width: 150,
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 11),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: [0.5, 1],
                      colors: [kOrange, kYellow],
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "SIGNIN",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kTextColor1,
                        fontWeight: FontWeight.w900,
                        fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkValidation() {
    if (_emailController.text.toString().trim().isEmpty ||
        _passwordController.text.toString().trim().isEmpty) {
      Utility.instance.showErrorToast("Please fill up all the field");
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text.toString().trim())) {
      Utility.instance.showErrorToast("Please enter valid email");
    } else if (_passwordController.text.toString().trim().length < 6) {
      Utility.instance.showErrorToast("Password must be at least 6 characters");
    } else {
      Map<String, String> body = {};
      body[Constants.EMAIL] = _emailController.text.toString().trim();
      body[Constants.PASSWORD] = _passwordController.text.toString().trim();
      _signInBloc = SignInBloc(body);
      _getResponse();
    }
  }

  _getResponse() async {
    if (_signInBloc != null) {
      _signInBloc.registerStream.listen((response) async {
        if (response != null) {
          switch (response.status) {
            case Status.LOADING:
              Utility.instance.innerLoader(context);
              break;
            case Status.COMPLETE:
              Navigator.of(context).pop();
              if (response.data != null) {
                Utility.instance.showSuccessToast(response.data.message);
                if (response.data.isSuccess) {
                  if (response.data.dataModel != null) {
                      await SharedPrefUtil.writeString(PreferenceKey.USER_EMAIL,
                          response.data.dataModel.email);
                      await SharedPrefUtil.writeBoolean(
                          PreferenceKey.IS_LOGGED_IN, true);
                      await SharedPrefUtil.writeString(
                          PreferenceKey.ACCESS_TOKEN,
                        response.data.dataModel.accessToken);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProfileActivity()));
                  } else {
                    Utility.instance.showErrorToast(response.data.message);
                  }
                } else {
                  Utility.instance.showErrorToast(response.data.message);
                }
              } else {
                Utility.instance
                    .showErrorToast("Could not sign in. Please try again.");
              }
              break;
            case Status.ERROR:
              Navigator.of(context).pop();
              Utility.instance.showErrorToast(response.message);
              break;
          }
        }
      });
    }
  }

}
