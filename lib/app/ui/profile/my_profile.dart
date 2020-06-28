import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:studentinfo/app/ui/profile/edit_profile_bloc.dart';
import 'package:studentinfo/helper/constants.dart';
import 'package:studentinfo/helper/util/utility_class.dart';

class ProfileActivity extends StatefulWidget {
  @override
  _ProfileActivityState createState() {
    return _ProfileActivityState();
  }
}

class _ProfileActivityState extends State<ProfileActivity> {
  // GetProfileBloc _getProfileBloc;
  bool isEditable = false;
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  PickedFile profileFile;
  final ImagePicker _picker = ImagePicker();
  bool isForProfile = true;
  bool notSync = false;
  String email = "", phone = "";
  List<String> currentEmailList = List<String>();
  List<String> currentPhoneList = List<String>();
  EditProfileBloc editProfileBloc;

  @override
  void initState() {
    _getProfileBloc = GetProfileBloc({});
    super.initState();
  }

  /* getFromShared() async {
    position = await SharedPrefUtil.getInt(PreferenceKey.IMAGE_POSITION);
    if (position != 0) {
      setState(() {});
    }
  }*/

  fromCamera() async {
    profileFile = await _picker.getImage(source: ImageSource.camera);
    setState(() {});
  }

  fromGallery() async {
    profileFile = await _picker.getImage(source: ImageSource.gallery);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: profileBuild(),
      /* RefreshIndicator(
        onRefresh: () => _getProfileBloc.getResponse({}),
        child: StreamBuilder<ApiResponse<ProfileResponse>>(
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
                    return noItemFound();
                  } else {
                    if (snapshot.data.data == null) {
                      Utility.instance.showErrorToast(snapshot.data.message);
                      return noItemFound();
                    } else {
                      if (snapshot.data.data.isSuccess) {
                        if (snapshot.data.data.dataModel != null) {
                          if (!notSync) {
                            email = snapshot.data.data.dataModel.email;
                            phone = snapshot.data.data.dataModel.phone;
                            snapshot.data.data.dataModel.emailList
                                .insert(0, snapshot.data.data.dataModel.email);
                            snapshot.data.data.dataModel.phoneList
                                .insert(0, snapshot.data.data.dataModel.phone);
                            notSync = true;
                          }
                          return profileBuild(snapshot.data.data.dataModel);
                        } else {
                          Utility.instance
                              .showErrorToast(snapshot.data.data.message);
                          return noItemFound();
                        }
                      }
                    }
                  }
                  break;
                case Status.ERROR:
                  return Error(
                    errorMessage: snapshot.data.message,
                    onRetryPressed: () => _getProfileBloc.getResponse({}),
                  );
                  break;
              }
            }
            return noItemFound();
          },
        ),
      ),*/
    );
  }

  getDateValue(String date) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  Widget profileBuild() {
    // _nameController.text = model.name;
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
                    onTap: (){
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
                            backgroundImage: profileFile == null
                                ? AssetImage("assets/images/avater.png")
                                : FileImage(File(profileFile
                                    .path)), //Image.file(File(profileFile.path)),
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
                            color: kHintTextColor1,
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
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: kHintTextColor1,
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
                    onTap: () {},
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

/*  getUpdateResponse() async {
    if (editProfileBloc != null) {
      editProfileBloc.editStream.listen((response) async {
        if (response != null) {
          switch (response.status) {
            case Status.LOADING:
              innerLoader();
              break;
            case Status.COMPLETE:
              Navigator.of(context).pop();
              if (response.data != null) {
                Utility.instance.showSuccessToast(response.data.message);
                if (response.data.isSuccess) {
                  setState(() {
                    isEditable = false;
                  });
                } else {
                  Utility.instance.showErrorToast(response.data.message);
                }
              } else {
                Utility.instance
                    .showErrorToast("Could not log out. Please try again.");
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
  }*/

  Widget noItemFound() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "No item found.",
        style: TextStyle(
            color: kTextColor2, fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
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
                    fromCamera();
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
                    fromGallery();
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
