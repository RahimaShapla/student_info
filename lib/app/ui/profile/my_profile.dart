import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:studentinfo/app/data/remote/register_response.dart';
import 'package:studentinfo/app/ui/profile/edit_profile_bloc.dart';
import 'package:studentinfo/app/ui/profile/get_profile_bloc.dart';
import 'package:studentinfo/helper/constants.dart';
import 'package:studentinfo/helper/network/api_response.dart';
import 'package:studentinfo/helper/util/loader.dart';
import 'package:studentinfo/helper/util/shared_preference.dart';
import 'package:studentinfo/helper/util/utility_class.dart';

class ProfileActivity extends StatefulWidget {
  @override
  _ProfileActivityState createState() {
    return _ProfileActivityState();
  }
}

class _ProfileActivityState extends State<ProfileActivity> {
  GetProfileBloc _getProfileBloc;
  bool isEditable = false;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String _message = '';
  var initializationSettings;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  get onDidRecieveLocalNotification => null;

  get flutterLocalNotificationsPlugin => null;
  FlutterLocalNotificationsPlugin plugin;

  PickedFile profileFile;
  String imagePath = "";
  final ImagePicker _picker = ImagePicker();
  EditProfileBloc editProfileBloc;

  @override
  void initState() {
    getFromShared();
    _getProfileBloc = GetProfileBloc({});
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidRecieveLocalNotification);

    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    plugin = new FlutterLocalNotificationsPlugin();
    plugin.initialize(initializationSettings);

    getMessage();
    super.initState();
  }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
      setState(() => _message = message["notification"]["title"]);
      displayNotification(message);
    }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
      displayNotification(message);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
      displayNotification(message);
    });
  }

  Future displayNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'channelid', 'flutterfcm', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await plugin.show(
      0,
      message['notification']['title'],
      message['notification']['body'],
      platformChannelSpecifics,
      payload: 'hello',
    );
  }

/*  Future<dynamic> onSelectNotification(String payload) async {
    Navigator.push(
      context,
      new MaterialPageRoute(builder: (context) => ProfileActivity()),
    );
  }*/

  getFromShared() async {
    if (await SharedPrefUtil.getBoolean(PreferenceKey.IS_LOGGED_IN)) {
      imagePath = await SharedPrefUtil.getString(PreferenceKey.IMAGE_PATH);
      setState(() {});
    }
  }

  fromCamera(bool isCamera) async {
    if (isCamera)
      profileFile = await _picker.getImage(source: ImageSource.camera);
    else
      profileFile = await _picker.getImage(source: ImageSource.gallery);
    imagePath = profileFile.path;
    await SharedPrefUtil.writeString(PreferenceKey.IMAGE_PATH, imagePath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _getProfileBloc.getProfile({}),
        child: StreamBuilder<ApiResponse<RegisterResponse>>(
          stream: _getProfileBloc.profileStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data.status) {
                case Status.LOADING:
                  return Loader();
                  break;
                case Status.COMPLETE:
                  if (snapshot.data == null) {
                    Utility.instance.showErrorToast("Something went wrong!");
                  } else {
                    if (snapshot.data.data == null) {
                      Utility.instance.showErrorToast(snapshot.data.message);
                    } else {
                      if (snapshot.data.data.isSuccess) {
                        if (snapshot.data.data.dataModel != null) {
                          _firstNameController.text =
                              snapshot.data.data.dataModel.firstName;
                          _lastNameController.text =
                              snapshot.data.data.dataModel.lastName;
                          _emailController.text =
                              snapshot.data.data.dataModel.email;
                          _phoneController.text =
                              snapshot.data.data.dataModel.phone;
                        } else {
                          Utility.instance
                              .showErrorToast(snapshot.data.data.message);
                        }
                      }
                    }
                  }
                  return profileBuild();
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _getProfileBloc.getProfile({}),
                  );
                  break;
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget profileBuild() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ic_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
              decoration: BoxDecoration(
                color: kTransBlack,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Utility.instance.showLogoutDialog(context);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 5, 20, 0),
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.power_settings_new,
                        color: kOrange,
                        size: 35,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      pickImage();
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 30),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kOrange,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: kOrange,
                            backgroundImage: imagePath == ""
                                ? AssetImage("assets/images/avater.png")
                                : FileImage(File(
                                    imagePath)), //Image.file(File(profileFile.path)),
                          ),
                        ),
                        Positioned.fill(
                          left: 70,
                          bottom: 50,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                                alignment: Alignment.center,
                                child: Icon(Icons.camera)),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
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
                          controller: _firstNameController,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: kTextColor1,
                            fontSize: 14.0,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(0, 13, 13, 14),
                                child: Icon(
                                  Icons.person,
                                  color: kTextColor1,
                                ),
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(100.0, 13, 0, 0),
                              //hoverColor: kYellow,
                              hintStyle: TextStyle(
                                color: kLightBlack,
                              ),
                              hintText: "First Name"),
                          //controller: phoneController,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 2.0),
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
                          controller: _lastNameController,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: kTextColor1,
                            fontSize: 14.0,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(0, 13, 13, 14),
                                child: Icon(
                                  Icons.person,
                                  color: kTextColor1,
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
                              hintText: "LastName"),
                          //controller: phoneController,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 2.0),
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
                          controller: _emailController,
                          textAlign: TextAlign.left,
                          enabled: false,
                          style: TextStyle(
                            color: kTextColor1,
                            fontSize: 14.0,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(0, 13, 13, 14),
                                child: Icon(
                                  Icons.email,
                                  color: kTextColor1,
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
                          //controller: phoneController,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 2.0),
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
                          enabled: false,
                          controller: _phoneController,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: kTextColor1,
                            fontSize: 14.0,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.fromLTRB(0, 13, 13, 14),
                                child: Icon(
                                  Icons.phone,
                                  color: kTextColor1,
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
                              hintText: "Phone"),
                          //controller: phoneController,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      editProfileBloc = EditProfileBloc(
                          _firstNameController.text.toString().trim(),
                          _lastNameController.text.toString().trim(),
                          imagePath);
                      getUpdateResponse();
                    },
                    child: Container(
                      width: 150,
                      margin: EdgeInsets.fromLTRB(100, 30, 100, 30),
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
                        "Update".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kTextColor1,
                            fontWeight: FontWeight.w900,
                            fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  popClass() {
    Navigator.pop(context);
  }

  getUpdateResponse() async {
    if (editProfileBloc != null) {
      editProfileBloc.editStream.listen((response) async {
        if (response != null) {
          switch (response.status) {
            case Status.LOADING:
              Utility.instance.innerLoader(context);
              break;
            case Status.COMPLETE:
              Timer(
                Duration(seconds: 1),
                popClass,
              );

              if (response.data != null) {
                if (response.data.isSuccess) {
                  Utility.instance.showSuccessToast(response.data.message);
                } else {
                  Utility.instance.showErrorToast(response.data.message);
                }
              } else {
                Utility.instance
                    .showErrorToast("Could not update. Please try again.");
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

  pickImage() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            "Choose from below: ",
            style: TextStyle(
              color: Colors.grey[900],
              fontSize: 18,
            ),
          ),
          content: Container(
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    fromCamera(true);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "1. From camera",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    fromCamera(false);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "2. From gallery",
                    style: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Error extends StatelessWidget {
  final String errorMessage;
  final Function onRetryPressed;

  const Error({Key key, this.errorMessage, this.onRetryPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kOrange,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          RaisedButton(
            color: kOrange,
            child: Text('Retry', style: TextStyle(color: Colors.white)),
            onPressed: onRetryPressed,
          )
        ],
      ),
    );
  }
}
