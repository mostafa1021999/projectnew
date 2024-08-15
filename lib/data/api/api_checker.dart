import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:six_pos/common/models/error_response.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/features/auth/screens/log_in_screen.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if(response.statusCode == 401) {
      Get.find<SplashController>().removeSharedData();
      Get.to(()=> const LogInScreen());
      // TODO: Auth Login
    }else {
      showCustomSnackBarHelper(response.body != null
          ? response.body['message'] ?? ErrorResponse.fromJson(response.body).errors?.first.message ?? ''
          : response.statusText, isError: true);
    }
  }

  static Future<Response> getResponse(http.StreamedResponse response) async {
    var r = await http.Response.fromStream(response);
    String error = '';
    try{
      error = jsonDecode(r.body)['errors'][0]['message'];
    }catch(e){
      error = jsonDecode(r.body)['message'] ?? 'failed'.tr;
    }
    return Response(statusText: error, statusCode: response.statusCode);
  }

}