import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:studentinfo/helper/constants.dart';
import 'package:studentinfo/helper/network/app_exception.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:studentinfo/helper/util/shared_preference.dart';

class ApiBaseHelper {
  final String _baseUrl = "https://google.com/api/";

  Future<dynamic> get(String endUrl, dynamic header) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + endUrl, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String endUrl, dynamic body, dynamic header) async {
    var responseJson;
    try {
      final response =
          await http.post(_baseUrl + endUrl, body: body, headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postMultipart(String endUrl, String firstName,
      String lastName, String profileFilePath) async {
    var responseJson;
    var rawStream;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(_baseUrl + endUrl));
      request.fields[Constants.FIRST_NAME] = firstName;
      request.fields[Constants.LAST_NAME] = lastName;
      request.headers[Constants.AUTHORIZATION] =
          await SharedPrefUtil.getString(PreferenceKey.ACCESS_TOKEN);
      if (profileFilePath.isNotEmpty) {
        var pic = await http.MultipartFile.fromPath(
            Constants.PROFILE_PICTURE, profileFilePath);
        request.files.add(pic);
      } else
        request.fields[Constants.PROFILE_PICTURE] = "";
      /*   var response = await request.send();
      rawStream = await http.Response.fromStream(response);*/
      responseJson = _returnResponse(rawStream);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) async {
    if (response != null)
      switch (response.statusCode) {
        case 200:
        case 400:
        //  throw BadRequestException(response.body.toString());
        case 401:
        case 403:
        // throw UnauthorisedException(response.body.toString());
        case 404:
        case 500:
          var value = await rootBundle.loadString("assets/raw_response.json");
          final responseJson = jsonDecode(value);
          return responseJson;
        // default:
        /*   throw FetchDataException('Error occured while Communication with '
            'Server with StatusCode : ${response.statusCode}');*/
        // }
      }
    else {
      var value = await rootBundle.loadString("assets/raw_response.json");
      final responseJson = jsonDecode(value);
      return responseJson;
    }
  }
}
