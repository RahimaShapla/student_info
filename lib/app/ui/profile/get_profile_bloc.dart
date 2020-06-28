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
    register(body);
  }

  register(Map<String, String> body) async {
    if(registerSink!=null) {
      registerSink.add(ApiResponse.loading("Wait......"));
      try {
        RegisterResponse response = await repository.signIn(body);
        registerSink.add(ApiResponse.completed(response));
      } on Exception catch (e) {
        registerSink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  dispose() {
    _categoryController?.close();
  }
}