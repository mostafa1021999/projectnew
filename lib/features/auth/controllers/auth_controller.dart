import 'dart:async';
import 'package:get/get.dart';
import 'package:six_pos/common/models/response_model.dart';
import 'package:six_pos/features/auth/domain/reposotories/auth_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';


class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool _isActiveRememberMe = false;

  bool get isLoading => _isLoading;
  bool get isActiveRememberMe => _isActiveRememberMe;


  Future<ResponseModel?> login({required String emailAddress,required String password}) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(emailAddress, password);
    ResponseModel? responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body['token']);
      responseModel = ResponseModel(true, 'successful');
      _isLoading = false;
    }else if(response.statusCode == 422){
      Map map = response.body;
      String? message = map['message'];
      showCustomSnackBarHelper(message, isError: true);
    } else {
      _isLoading = true;
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void setRememberMe() {
    _isActiveRememberMe = true;
    update();
  }



  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  Future<bool> clearSharedData() async {
    return await authRepo.clearSharedData();
  }

  void saveUserEmailAndPassword({required String emailAddress,required String password}) {
    authRepo.saveUserEmailAndPassword(emailAddress, password);
  }

  String getUserEmail() {
    return authRepo.getUserEmail();
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode();
  }

  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  Future<bool> clearUserEmailAndPassword() async {
    return authRepo.clearUserEmailAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }


}