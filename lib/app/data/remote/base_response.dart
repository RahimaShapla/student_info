
import 'package:studentinfo/helper/constants.dart';

class BaseResponse{
  String message;
  bool isSuccess;
  dynamic dataModel;

  BaseResponse();

  BaseResponse.fromJson(Map<String, dynamic> json) {
    message = json[JsonString.MESSAGE];
    isSuccess = json[JsonString.SUCCESS];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data[JsonString.MESSAGE] = this.message;
    data[JsonString.SUCCESS] = this.isSuccess;

    return data;
  }
}