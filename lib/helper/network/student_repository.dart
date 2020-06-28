import 'package:studentinfo/app/data/remote/register_response.dart';
import 'package:studentinfo/helper/constants.dart';
import 'package:studentinfo/helper/network/api_base_helper.dart';

class StudentRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

 Future<RegisterResponse> signIn(Map<String, String> body) async {
    Map<String, String> header = {};
    final response = await _helper.post(EndUrls.SIGN_IN, body, header);
    return RegisterResponse.fromJson(response);
  }

/* Future<ProfileResponse> getProfile(Map<String, String> body) async {
    Map<String, String> header = {};
    header[Constants.AUTHORIZATION] = await SharedPrefUtil.getString(PreferenceKey.ACCESS_TOKEN);
    header[Constants.ACCEPT] = accept;
    final response = await _helper.get(EndUrls.GET_PROFILE, header);
    return ProfileResponse.fromJson(response);
  }*/

}
