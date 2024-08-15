import 'package:flutter/foundation.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class ProfileRepo {
  ApiClient apiClient;
  ProfileRepo({ required this.apiClient});

  Future<Response> getProfile() async {
    return await apiClient.getData(AppConstants.getProfileUri);
  }

  Future<Response> getDashboardRevenueSummery(String? filterType) async {
    Response response = await apiClient.getData('${AppConstants.getDashboardRevenueSummeryUri}?statistics_type=$filterType');
    return response;
  }


  Future<http.StreamedResponse> updateShop( BusinessInfo shop,  XFile? file,  String token,) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateShopUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null) {
      Uint8List list = await file.readAsBytes();
      var part = http.MultipartFile('shop_logo', file.readAsBytes().asStream(), list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'pagination_limit': shop.paginationLimit!,
      'currency': shop.currency!,
      'shop_name': shop.shopName!,
      'shop_address': shop.shopAddress!,
      'shop_phone': shop.shopPhone!,
      'shop_email':shop.shopEmail!,
      'footer_text': shop.footerText!,
      'country': shop.country!,
      'stock_limit': shop. stockLimit!,
      'time_zone': shop.timeZone!,
      'vat_reg_no': shop.vat!,
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
}
