import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class BrandRepo{
  ApiClient apiClient;
  BrandRepo({required this.apiClient});

  Future<Response> getBrandList(int offset, int limit) async {
    return await apiClient.getData('${AppConstants.getBrandListUri}?limit=$limit&offset=$offset');
  }

  Future<http.StreamedResponse> addBrand(String brandName,int? brandId,  XFile? file, String token, {required bool isUpdate}) async {
    http.MultipartRequest request = isUpdate? http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateBrandUri}')):
    http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.addBrandUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    if(file != null) {
      Uint8List list = await file.readAsBytes();
      var part = http.MultipartFile('image', file.readAsBytes().asStream(), list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'id': brandId.toString(),
      'name': brandName,
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<Response> deleteBrand(int? brandId) async {
    return await apiClient.getData('${AppConstants.deleteBrandUri}?id=$brandId');
  }


}