
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
  String name;
  String email;
  String phone;
  String accessToken;

  UserModel();

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json[JsonString.ID];
    name = json[JsonString.NAME];
    email = json[JsonString.EMAIL];
    phone = json[JsonString.PHONE];
    accessToken = json[JsonString.ACCESS_TOKEN];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[JsonString.ID] = this.id;
    data[JsonString.NAME] = this.name;
    data[JsonString.EMAIL] = this.email;
    data[JsonString.PHONE] = this.phone;
    data[JsonString.ACCESS_TOKEN] = this.accessToken;
    return data;
  }

}


