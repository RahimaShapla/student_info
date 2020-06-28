
import 'package:studentinfo/helper/constants.dart';

class RegisterResponse{
  String message;
  bool isSuccess;
  UserModel dataModel;

  RegisterResponse();

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    message = json[JsonString.MESSAGE];
    isSuccess = json[JsonString.SUCCESS];
    if (json[JsonString.DATA] != null) {
      dataModel = UserModel();
      dataModel = UserModel.fromJson(json[JsonString.DATA]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[JsonString.MESSAGE] = this.message;
    data[JsonString.SUCCESS] = this.isSuccess;
    if (this.dataModel != null) {
      data[JsonString.DATA] = dataModel.toJson();
    }
    return data;
  }
}

class UserModel{
  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String accessToken;

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json[JsonString.ID];
    firstName = json[JsonString.FIRST_NAME];
    lastName = json[JsonString.LAST_NAME];
    email = json[JsonString.EMAIL];
    phone = json[JsonString.PHONE];
    accessToken = json[JsonString.ACCESS_TOKEN];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[JsonString.ID] = this.id;
    data[JsonString.FIRST_NAME] = this.firstName;
    data[JsonString.LAST_NAME] = this.lastName;
    data[JsonString.EMAIL] = this.email;
    data[JsonString.PHONE] = this.phone;
    data[JsonString.ACCESS_TOKEN] = this.accessToken;
    return data;
  }

}


