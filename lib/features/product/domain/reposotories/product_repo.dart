import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class ProductRepo{
  ApiClient apiClient;
  ProductRepo({required this.apiClient});


  Future<Response> getProductList(int offset) async {
    return await apiClient.getData('${AppConstants.getProductUri}?limit=10&offset=$offset');
  }

  Future<Response> getSupplierProductList(int offset, int? supplierId) async {
    return await apiClient.getData('${AppConstants.supplierProductListUri}?limit=10&offset=$offset&supplier_id=$supplierId');
  }

  Future<Response> getLimitedStockProductList(int offset) async {
    return await apiClient.getData('${AppConstants.getLimitedStockProductUri}?limit=10&offset=$offset');
  }



  Future<Response> updateProductQuantity(int? productId, int quantity) async {
    return await apiClient.getData('${AppConstants.updateProductQuantity}?id=$productId&quantity=$quantity');
  }




  Future<http.StreamedResponse> addProduct(Products product,String categoryId,String subCategoryId,int? brandId,int? supplierId, XFile? file, String token,{bool isUpdate = false}) async {
    http.MultipartRequest request = isUpdate ? http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.updateProductUri}')):
    http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.addProductUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(file != null) {
      Uint8List list = await file.readAsBytes();
      var part = http.MultipartFile('image', file.readAsBytes().asStream(), list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'id':product.id.toString(),
      'name': product.title!,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
      'product_code': product.productCode!,
      'unit_type': product.unitType.toString(),
      'unit_value': '${product.unitValue}',
      'quantity': product.quantity.toString(),
      'purchase_price': product.purchasePrice.toString(),
      'selling_price': product.sellingPrice.toString(),
      'tax':product.tax.toString(),
      'discount':product.discount.toString(),
      'discount_type':product.discountType!,
      'brand':brandId.toString(),
      'supplier_id': supplierId.toString()
    });
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
  Future<Response> searchProduct(String productName, int offset) async {
    return await apiClient.getData('${AppConstants.productSearchUri}?limit=10&offset=$offset&name=$productName');
  }


  Future<http.StreamedResponse> bulkImport(File? filePath, String token) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.bulkImportProductUri}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if(filePath != null) {
      Uint8List list = await filePath.readAsBytes();
      var part = http.MultipartFile('products_file', filePath.readAsBytes().asStream(), list.length, filename: basename(filePath.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{

    });

    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }






  Future<Response> bulkExport() async {
    return await apiClient.getData(AppConstants.bulkExportProductUri);
  }

  Future<Response> downloadSampleFile() async {
    return await apiClient.getData(AppConstants.getDownloadSampleFileUri);
  }


  Future<Response> deleteProduct(int? productId) async {
    return await apiClient.getData('${AppConstants.productDeleteUri}?id=$productId');
  }

  Future<Response> barCodeDownLoad( int id, int quantity) async {
    return await apiClient.getData('${AppConstants.barCodeDownload}?id=$id&quantity=$quantity');
  }

}