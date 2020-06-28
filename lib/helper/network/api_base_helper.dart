import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:studentinfo/helper/network/app_exception.dart';
import 'package:flutter/services.dart' show rootBundle;

class ApiBaseHelper {
  final String _baseUrl = "https://google.com/api/";

  Future<dynamic> get(String endUrl, dynamic header) async {
    var responseJson;
    try {
      final response = await http.get(_baseUrl + endUrl, headers: header);
      //  responseJson = _returnResponse(response);
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

  Future<dynamic> postMulti(String endUrl,
      String accept,
      String name,
      PickedFile profileFilePath) async {
    var responseJson;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(_baseUrl + endUrl));
/*      request.fields[Constants.NAME] = name;
      request.headers[Constants.AUTHORIZATION] =
          await SharedPrefUtil.getString(PreferenceKey.ACCESS_TOKEN);
      request.headers[Constants.ACCEPT] = accept;*/

      /*     if (profileFilePath != null) {
        var pic = await http.MultipartFile.fromPath(
            Constants.DEFAULT_IMAGE, profileFilePath.path);
        request.files.add(pic);
      } else
        request.fields[Constants.DEFAULT_IMAGE] = "";*/


      var response = await request.send();

      var responses = await http.Response.fromStream(response);

      //   responseJson = _returnResponse(responses);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
      case 400:
      //  throw BadRequestException(response.body.toString());
      case 401:
      case 403:
      case 404:
      // throw UnauthorisedException(response.body.toString());
      case 500:
        var value = await rootBundle.loadString("assets/config.json");
        final responseJson = jsonDecode(value);
        return responseJson;
    // default:
    /*   throw FetchDataException('Error occured while Communication with '
            'Server with StatusCode : ${response.statusCode}');*/
    // }
    }
  }
}
