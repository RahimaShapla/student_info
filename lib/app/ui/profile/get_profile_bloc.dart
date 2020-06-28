import 'dart:async';

import 'package:studentinfo/app/data/remote/register_response.dart';
import 'package:studentinfo/helper/network/api_response.dart';
import 'package:studentinfo/helper/network/student_repository.dart';


class GetProfileBloc{
  StudentRepository repository;
  StreamController _categoryController;

  StreamSink<ApiResponse<RegisterResponse>> get profileSink =>
      _categoryController.sink;


  Stream<ApiResponse<RegisterResponse>> get profileStream =>
      _categoryController.stream;

  GetProfileBloc(Map<String, String> body) {
    _categoryController = StreamController<ApiResponse<RegisterResponse>>();
    repository = StudentRepository();
    getProfile(body);
  }

  getProfile(Map<String, String> body) async {
    if(profileSink!=null) {
      profileSink.add(ApiResponse.loading("Wait......"));
      try {
        RegisterResponse response = await repository.getProfile(body);
        profileSink.add(ApiResponse.completed(response));
      } on Exception catch (e) {
        profileSink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  dispose() {
    _categoryController?.close();
  }
}