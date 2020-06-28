import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:studentinfo/app/data/remote/base_response.dart';
import 'package:studentinfo/helper/network/api_response.dart';
import 'package:studentinfo/helper/network/student_repository.dart';

class EditProfileBloc{
  StudentRepository repository;
  StreamController _categoryController;

  StreamSink<ApiResponse<BaseResponse>> get editSink =>
      _categoryController.sink;


  Stream<ApiResponse<BaseResponse>> get editStream =>
      _categoryController.stream;

  EditProfileBloc(String firstName, String lastName, String profileFilePath) {
    _categoryController = StreamController<ApiResponse<BaseResponse>>();
    repository = StudentRepository();
    getResponse(firstName, lastName, profileFilePath);
  }

  getResponse(String firstName, String lastName, String profileFilePath) async {
    if(editSink!=null) {
      editSink.add(ApiResponse.loading("Wait......"));
      try {
        BaseResponse response = await repository.editProfile(firstName, lastName, profileFilePath);
        editSink.add(ApiResponse.completed(response));
      } on Exception catch (e) {
        editSink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  dispose() {
    _categoryController?.close();
  }
}