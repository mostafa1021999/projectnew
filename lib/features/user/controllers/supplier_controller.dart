
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/features/user/domain/models/supplier_model.dart';
import 'package:six_pos/features/user/domain/models/supplier_profile_model.dart' as profile;
import 'package:six_pos/features/account_management/domain/models/transaction_model.dart';
import 'package:six_pos/features/user/domain/reposotories/supplier_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;
import 'package:six_pos/common/models/response_model.dart';


class SupplierController extends GetxController implements GetxService{
  final SupplierRepo supplierRepo;
  SupplierController({required this.supplierRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  SupplierModel? _supplierModel;
  SupplierModel? get supplierModel=> _supplierModel;
  int? _selectedSupplierId;
  int? get selectedSupplierId => _selectedSupplierId;

  profile.Supplier? _supplierProfile;
  profile.Supplier? get supplierProfile =>_supplierProfile;

  TransactionModel? _transactionModel;
  TransactionModel? get transactionModel => _transactionModel;



  final picker = ImagePicker();
  XFile? _supplierImage;
  XFile? get supplierImage=> _supplierImage;
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _supplierImage = null;
    }else {
      _supplierImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  Future<http.StreamedResponse> addSupplier(Suppliers supplier, bool isUpdate) async {

    _isLoading = true;
    update();
    http.StreamedResponse response = await supplierRepo.addSupplier(supplier, _supplierImage, Get.find<AuthController>().getUserToken(), isUpdate: isUpdate);

    if(response.statusCode == 200) {
      _supplierImage = null;
      await getSupplierList(1);
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper(isUpdate? 'supplier_updated_successfully'.tr : 'supplier_added_successfully'.tr, isError: false);

    }else {
      _isLoading = false;
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> getSupplierList( int offset, {Products? product, bool isUpdate = true, int limit = 10}) async {
    if(offset == 1){
      _supplierModel = null;

      if(isUpdate) {
        update();
      }
    }
    _selectedSupplierId = null;


    Response response = await supplierRepo.getSupplierList(offset, limit);

    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _supplierModel = SupplierModel.fromJson(response.body);

      }else {
        _supplierModel?.offset = SupplierModel.fromJson(response.body).offset;
        _supplierModel?.totalSize = SupplierModel.fromJson(response.body).totalSize;
        _supplierModel?.supplierList?.addAll(SupplierModel.fromJson(response.body).supplierList ?? []);

      }

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }



  Future<void> searchSupplier(String name) async {
    if(name.isNotEmpty) {
      _supplierModel = null;
      update();

      Response response = await supplierRepo.searchSupplier(name);

      if(response.statusCode == 200 && response.body != null) {
        _supplierModel = SupplierModel.fromJson(response.body);

      }else {
        ApiChecker.checkApi(response);
      }
      update();
    }else {
      await getSupplierList(1);
    }
  }


  Future<void> deleteSupplier(int? supplierId) async {

    Response response = await supplierRepo.deleteSupplier(supplierId);
    if(response.statusCode == 200) {
      getSupplierList(1);
      Get.back();
      showCustomSnackBarHelper('supplier_deleted_successfully'.tr, isError: false);


    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }



  Future<void> getSupplierProfile(int? supplierId) async {
    Response response = await supplierRepo.getSupplierProfile(supplierId);
    if(response.statusCode == 200) {
      _supplierProfile = profile.SupplierProfileModel.fromJson(response.body).supplier;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }




  Future<void> getSupplierTransactionList(int offset, int? supplierId, {bool isUpdate = true}) async {
    if(offset == 1){
      _transactionModel = null;

      if(isUpdate) {
        update();
      }
    }
    Response response = await supplierRepo.getSupplierTransactionList(offset, supplierId);

    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _transactionModel = TransactionModel.fromJson(response.body);

      }else {
        _transactionModel?.offset = TransactionModel.fromJson(response.body).offset;
        _transactionModel?.totalSize = TransactionModel.fromJson(response.body).totalSize;
        _transactionModel?.transferList?.addAll(TransactionModel.fromJson(response.body).transferList ?? []);
      }

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }




  Future<void> getSupplierTransactionFilterList(int offset, int? supplierId, DateTime fromDate, DateTime toDate) async {

    if(offset == 1){
      _transactionModel = null;

      update();
    }
    Response response = await supplierRepo.getSupplierTransactionFilterList(
      offset, supplierId, dateFormat.format(fromDate), dateFormat.format(toDate),
    );

    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _transactionModel = TransactionModel.fromJson(response.body);

      }else {
        _transactionModel?.offset = TransactionModel.fromJson(response.body).offset;
        _transactionModel?.totalSize = TransactionModel.fromJson(response.body).totalSize;
        _transactionModel?.transferList?.addAll(TransactionModel.fromJson(response.body).transferList ?? []);
      }

    }else {
      ApiChecker.checkApi(response);
    }

    update();
  }


  Future<ResponseModel?> supplierNewPurchase(int? supplierId, double purchaseAmount, double paidAmount, double dueAmount, int? paymentAccountId) async {

    _isLoading = true;
    update();
    Response response = await supplierRepo.supplierNewPurchase(supplierId, purchaseAmount,paidAmount,dueAmount,paymentAccountId);
    ResponseModel? responseModel;
    if(response.statusCode == 200){
      getSupplierProfile(supplierId);
      getSupplierTransactionList(1,supplierId);
      Get.back();
      showCustomSnackBarHelper('purchase_completed_successfully'.tr , isError: false);
      _isLoading = false;
    }else{
      _isLoading = false;
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }



  Future<ResponseModel?> supplierPayment(int? supplierId, double? totalDueAmount, double payAmount, double remainingDueAmount, int? paymentAccountId) async {

    _isLoading = true;
    update();
    Response response = await supplierRepo.supplierPayment(supplierId, totalDueAmount, payAmount, remainingDueAmount, paymentAccountId);
    ResponseModel? responseModel;
    if(response.statusCode == 200){
      getSupplierProfile(supplierId);
      getSupplierTransactionList(1,supplierId);

      Get.back();
      showCustomSnackBarHelper('payment_completed_successfully'.tr , isError: false);
      _isLoading = false;
    }else{
      _isLoading = false;
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }




  void removeImage(){
    _supplierImage = null;
    update();
  }


  void setSupplierIndex(int? index, bool notify) {
    _selectedSupplierId = index;
    if(notify) {
      update();
    }
  }

  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

  void clearSelectedDate() {
    _startDate = null;
    _endDate = null;
  }


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
}