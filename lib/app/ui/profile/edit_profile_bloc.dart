import 'dart:async';
import 'package:image_picker/image_picker.dart';

class EditProfileBloc{
  /*BondRepository repository;
  StreamController _categoryController;

  StreamSink<ApiResponse<BaseResponse>> get editSink =>
      _categoryController.sink;


  Stream<ApiResponse<BaseResponse>> get editStream =>
      _categoryController.stream;

  EditProfileBloc(String name, PickedFile profileFilePath) {
    _categoryController = StreamController<ApiResponse<BaseResponse>>();
    repository = BondRepository();
    getResponse(name, email, phone, emailList, phoneList, address, facebook, insta, whatapp, tele, time, profileFilePath, coverFilePath);
  }

  getResponse(String name, String email, String phone, String emailList, String phoneList, String address, String facebook,
      String insta, String whatapp, String tele, String time, PickedFile profileFilePath, PickedFile coverFilePath) async {
    if(editSink!=null) {
      editSink.add(ApiResponse.loading("Wait......"));
      try {
        BaseResponse response = await repository.editProfile(name, email, phone, emailList, phoneList,
            address, facebook, insta, whatapp, tele, time, profileFilePath, coverFilePath);
        editSink.add(ApiResponse.completed(response));
      } on Exception catch (e) {
        editSink.add(ApiResponse.error(e.toString()));
      }
    }
  }

  dispose() {
    _categoryController?.close();
  }*/
}