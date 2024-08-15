import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/common/models/customer_model.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class CustomerRepo{
  ApiClient apiClient;
  CustomerRepo({required this.apiClient});

  Future<Response> getCustomerList(int offset) async {
    return await apiClient.getData('${AppConstants.getCustomerListUri}?limit=10&offset=$offset');
  }

  Future<Response> getCustomerWiseOrderList(int? customerId ,int offset) async {
    return await apiClient.getData('${AppConstants.customerWiseOrderListUri}?customer_id=$customerId&limit=10&offset=$offset');
  }



  Future<Response> customerSearch(String name) async {
    return await apiClient.getData('${AppConstants.customerSearchUri}?name=$name');
  }

  Future<Response> updateCustomerBalance(int? customerId, int? accountId, double amount, String date, String description) async {
    return await apiClient.postData(AppConstants.customerBalanceUpdate,{
      'customer_id': customerId,
      'amount': amount,
      'account_id': accountId,
      'description': description,
      'date': date
    });
  }


  Future<Response> deleteCustomer(int? customerId) async {
    return await apiClient.getData('${AppConstants.deleteCustomerUri}?id=$customerId');
  }


  Future<http.StreamedResponse> addCustomer(Customers customer, XFile? file, String token, {bool isUpdate = false}) async {
    http.MultipartRequest request = isUpdate? http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateCustomerUri}')):
    http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.addNewCustomerUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    if(file != null) {
      Uint8List list = await file.readAsBytes();
      var part = http.MultipartFile('image', file.readAsBytes().asStream(), list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'id': customer.id.toString(),
      'name': customer.name!,
      'mobile': customer.mobile!,
      'email': customer.email!,
      'state': customer.state!,
      'city': customer.city!,
      'zip_code': customer.zipCode!,
      'address': customer.address!,
      'balance': '0.0',
      '_method': isUpdate? 'put': 'post'
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

}