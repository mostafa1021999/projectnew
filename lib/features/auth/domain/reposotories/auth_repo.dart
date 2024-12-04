import 'dart:async';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> login(String email, String password) async {
    return await apiClient.postData(AppConstants.loginUri, {"email": email, "password": password});
  }

  Future<Response> sendCodeEmail(String email) async {
    return await apiClient.postData(AppConstants.sendCodeUri, {"email": email,});
  }

  Future<Response> checkCode(String email, String otp) async {
    return await apiClient.postData(AppConstants.verifyCodeUri, {"email": email, "otp": otp});
  }
  Future<Response> changePassword(String email, String password,String confirm,) async {
    return await apiClient.postData(AppConstants.changePasswordUri, {"email": email, "password": password,"confirm_password":confirm});
  }
  Future<Response> postUserData(String actionAr, String actionEn,) async {
    return await apiClient.postData(AppConstants.userActivities, {"action_ar": actionAr, "action_en": actionEn,});
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  Future<bool> clearSharedData() async {
    await sharedPreferences.remove(AppConstants.token);
    return true;
  }

  Future<void> saveUserEmailAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userEmail, number);
    } catch (e) {
      rethrow;
    }
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstants.userEmail) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.userCountryCode) ?? "";
  }




  Future<bool> clearUserEmailAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    return await sharedPreferences.remove(AppConstants.userEmail);
  }
}
