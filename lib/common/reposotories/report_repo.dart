import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class ReportRepo{
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  ReportRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getTopProductReport(String startDate,String endDate,keyList,String lang) async {
    return await apiClient.getData('${AppConstants.getProductReportUri}?startDate=$startDate&endDate=$endDate&lang=$lang&key=$keyList',);
  }
  Future<Response> getLowProductReport(String startDate,String endDate,keyList,String lang) async {
    return await apiClient.getData('${AppConstants.getProductReportUri}?startDate=$startDate&endDate=$endDate&lang=$lang&key=$keyList',);
  }
  Future<Response> getUserActivitiesReport(String startDate,String endDate,String lang,{String? filterId}) async {
    return filterId!=null? await apiClient.getData('${AppConstants.userActivitiesReport}?user_id=$filterId&startDate=$startDate&endDate=$endDate&lang=$lang',):
    await apiClient.getData('${AppConstants.userActivitiesReport}?startDate=$startDate&endDate=$endDate&lang=$lang',);
  }
}