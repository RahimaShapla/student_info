import 'package:image_picker/image_picker.dart';
import 'package:studentinfo/app/data/remote/base_response.dart';
import 'package:studentinfo/app/data/remote/register_response.dart';
import 'package:studentinfo/helper/constants.dart';
import 'package:studentinfo/helper/network/api_base_helper.dart';
import 'package:studentinfo/helper/util/shared_preference.dart';

class StudentRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  Future<RegisterResponse> signIn(Map<String, String> body) async {
    Map<String, String> header = {};
    final response = await _helper.post(EndUrls.SIGN_IN, body, header);
    return RegisterResponse.fromJson(response);
  }

  Future<RegisterResponse> getProfile(Map<String, String> body) async {
    Map<String, String> header = {};
    header[Constants.AUTHORIZATION] =
        await SharedPrefUtil.getString(PreferenceKey.ACCESS_TOKEN);
    final response = await _helper.get(EndUrls.GET_PROFILE, header);
    return RegisterResponse.fromJson(response);
  }

  Future<BaseResponse> editProfile(
      String firstName, String lastName, String profileFilePath) async {
    final response = await _helper.postMultipart(
        EndUrls.UPDATE_PROFILE, firstName, lastName, profileFilePath);
    return BaseResponse.fromJson(response);
  }
}
