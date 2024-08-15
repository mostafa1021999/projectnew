
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/features/user/domain/models/supplier_model.dart';
import 'package:six_pos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class SupplierRepo{
  ApiClient apiClient;
  SupplierRepo({required this.apiClient});

  Future<Response> getSupplierList(int offset, int limit) async {
    return await apiClient.getData('${AppConstants.getSupplierListUri}?limit=$limit&offset=$offset');
  }

  Future<Response> getSupplierProfile(int? sellerId) async {
    return await apiClient.getData('${AppConstants.supplierProfileUri}?id=$sellerId');
  }



  Future<Response> getSupplierTransactionList(int offset, int? supplierId) async {
    return await apiClient.getData('${AppConstants.supplierTransactionListUri}?limit=10&offset=$offset&supplier_id=$supplierId');
  }

  Future<Response> getSupplierTransactionFilterList(int offset, int? supplierId, String fromDate, String toDate) async {
    return await apiClient.getData('${AppConstants.supplierTransactionFilterListUri}?supplier_id=$supplierId&limit=10&offset=$offset&from=$fromDate&to=$toDate');
  }

  Future<Response> supplierNewPurchase(int? supplierId, double purchaseAmount, double paidAmount, double dueAmount, int? paymentAccountId) async {
    return await apiClient.postData(AppConstants.newPurchaseFromSupplier, {
      'supplier_id': supplierId,
      'purchased_amount': purchaseAmount,
      'paid_amount': paidAmount,
      'due_amount' : dueAmount,
      'payment_account_id': paymentAccountId

    });
  }


  Future<Response> supplierPayment(int? supplierId, double? totalDueAmount, double payAmount, double remainingDueAmount, int? paymentAccountId) async {
    return await apiClient.postData(AppConstants.supplierPayment, {
      'supplier_id': supplierId,
      'total_due_amount': totalDueAmount,
      'pay_amount': payAmount,
      'remaining_due_amount' : remainingDueAmount,
      'payment_account_id': paymentAccountId
    });
  }




  Future<Response> searchSupplier(String name) async {
    return await apiClient.getData('${AppConstants.searchSupplierUri}?name=$name');
  }


  Future<http.StreamedResponse> addSupplier(Suppliers supplier, XFile? file, String token, {bool isUpdate = false}) async {
    http.MultipartRequest request = isUpdate? http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateSupplierUri}')):
    http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.addSupplierUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    if(file != null) {
      Uint8List list = await file.readAsBytes();
      var part = http.MultipartFile('image', file.readAsBytes().asStream(), list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'id': supplier.id.toString(),
      'name': supplier.name!,
      'mobile': supplier.mobile!,
      'state': supplier.state!,
      'city': supplier.city!,
      'zip_code': supplier.zipCode!,
      'address': supplier.address!,
      'email': supplier.email!,
      'due_amount': '0.0',
      '_method': isUpdate? 'put' : 'post'
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();

    return response;
  }

  Future<Response> deleteSupplier(int? supplierId) async {
    return await apiClient.getData('${AppConstants.deleteSupplierUri}?id=$supplierId');
  }
}