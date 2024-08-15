import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/common/models/customer_model.dart';
import 'package:six_pos/common/models/order_model.dart';
import 'package:six_pos/features/user/domain/reposotories/customer_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;

class CustomerController extends GetxController implements GetxService{
  final CustomerRepo customerRepo;
  CustomerController({required this.customerRepo});

  bool _isLoading = false;
  bool _isGetting = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isGetting => _isGetting;
  bool get isLoading => _isLoading;

  // int? _customerListLength;
  // int? get customerListLength => _customerListLength;

  //
  // List<Customers> _customerList = [];
  // List<Customers> get customerList =>_customerList;
  CustomerModel? _customerModel;
  CustomerModel? get customerModel => _customerModel;


  List<Orders> _customerWiseOrderList = [];
  List<Orders> get customerWiseOrderList =>_customerWiseOrderList;

  int? _customerWiseOrderListLength;
  int? get customerWiseOrderListLength => _customerWiseOrderListLength;




  int _offset = 1;
  int get offset => _offset;


  final picker = ImagePicker();
  XFile? _customerImage;
  XFile? get customerImage=> _customerImage;
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _customerImage = null;
    }else {
      _customerImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }


  void setOffset(int offset) {
    _offset = _offset + 1;
  }


  Future<http.StreamedResponse> addCustomer(Customers customer, bool isUpdate) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await customerRepo.addCustomer(customer, _customerImage, Get.find<AuthController>().getUserToken(), isUpdate: isUpdate);

    if(response.statusCode == 200) {
      _customerImage = null;
      await getCustomerList(1);
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper(isUpdate ? 'customer_updated_successfully'.tr : 'customer_added_successfully'.tr, isError: false);

    }else {
      String? message;
      try{
        Map map = jsonDecode(await response.stream.bytesToString());
        message = map["message"];
      }catch(_) {
        message = null;
      }
      showCustomSnackBarHelper(message ??  (isUpdate ? 'customer_update_failed'.tr : 'customer_add_failed'.tr));

    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> getCustomerList(int offset, {bool isUpdate = true}) async {
    if(offset == 1){
      _customerModel = null;

      if(isUpdate) {
        update();
      }
    }
    // _isGetting = true;
    Response response = await customerRepo.getCustomerList(offset);
    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _customerModel = CustomerModel.fromJson(response.body);

      }else {
        _customerModel?.offset = CustomerModel.fromJson(response.body).offset;
        _customerModel?.totalSize = CustomerModel.fromJson(response.body).totalSize;
        _customerModel?.customerList?.addAll(CustomerModel.fromJson(response.body).customerList ?? []);

      }

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> updateCustomerBalance(int? customerId, int? accountId, double amount, String date , String description) async {
    _isLoading = true;
    update();
    Response response = await customerRepo.updateCustomerBalance(customerId,accountId, amount,date, description);
    if(response.statusCode == 200) {
      Get.back();
      getCustomerList(1);
      showCustomSnackBarHelper('customer_balance_updated_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    _isGetting = false;
    update();
  }



  Future<void> getCustomerWiseOrderListList(int? customerId ,int offset, {bool reload = true}) async {
    _offset = offset;
    if(reload){
      _customerWiseOrderList = [];
      _isFirst = true;
    }
    _isGetting = true;
    Response response = await customerRepo.getCustomerWiseOrderList(customerId, offset);
    if(response.statusCode == 200) {
      _customerWiseOrderList.addAll(OrderModel.fromJson(response.body).orderList ?? []);
      _customerWiseOrderListLength = OrderModel.fromJson(response.body).totalSize;
      _isGetting = false;
      _isFirst = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }


  Future<void> filterCustomerList(String searchName) async {
    _customerModel = null;
    update();
    Response response = await customerRepo.customerSearch(searchName);

    if(response.statusCode == 200 && response.body != null) {
      _customerModel = CustomerModel.fromJson(response.body);

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> deleteCustomer(int? customerId) async {
    _isGetting = true;

    Response response = await customerRepo.deleteCustomer(customerId);
    if(response.statusCode == 200) {
      getCustomerList(1);
      _isGetting = false;
      Get.back();
      showCustomSnackBarHelper('customer_deleted_successfully'.tr, isError: false);


    }else {
      ApiChecker.checkApi(response);
    }
    _isGetting = false;
    update();
  }


  void removeImage(){
    _customerImage = null;
    update();
  }

  void showBottomLoader() {
    _isGetting = true;
    update();
  }

  void removeFirstLoading() {
    _isFirst = true;
    update();
  }


  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

  void selectDate(String type, BuildContext context){
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      if (type == 'start'){
        _startDate = date;
      }else{
        _endDate = date;
      }
      if(date == null){

      }
      update();
    });
  }

  void clearDate() {
    _startDate = null;
    _endDate = null;
  }




}