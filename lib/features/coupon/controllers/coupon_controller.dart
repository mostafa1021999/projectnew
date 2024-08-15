import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/coupon/domain/models/coupon_model.dart';
import 'package:six_pos/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';

class CouponController extends GetxController implements GetxService{
  final CouponRepo couponRepo;
  CouponController({required this.couponRepo});


  CouponModel? _couponModel;
  CouponModel? get couponModel => _couponModel;


  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<void> getCouponList( int offset, {bool isUpdate = false}) async {

    if(offset == 1) {
      _couponModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await couponRepo.getCouponList(offset);
    if(response.statusCode == 200 && response.body != null) {

      if(offset == 1) {
        _couponModel = CouponModel.fromJson(response.body);
      }else{
        _couponModel?.offset = CouponModel.fromJson(response.body).offset;
        _couponModel?.totalSize = CouponModel.fromJson(response.body).totalSize;
        _couponModel?.couponList?.addAll(CouponModel.fromJson(response.body).couponList ?? []);
      }

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> deleteCoupon( int? couponId) async {
    _isLoading = true;
    Response response = await couponRepo.deleteCoupon(couponId);
    if(response.statusCode == 200) {
      _isLoading = false;
      getCouponList(1);
      Get.back();
      showCustomSnackBarHelper('coupon_deleted_successfully'.tr, isError: false);

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> toggleCouponStatus(int? couponId, int status, int? index) async {
    Response response = await couponRepo.toggleCouponStatus(couponId, status);
    if(response.statusCode == 200){
      _couponModel?.couponList?[index!].status = status;
      showCustomSnackBarHelper('coupon_status_updated_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }


  int _dropDownPosition = 0;
  final List<String> _dropDownValues =[];

  int get dropDownPosition => _dropDownPosition;
  List<String> get dropDownValues => _dropDownValues;

  Future<void> addCoupon(Coupons coupon, bool isUpdate) async {
    _isLoading = true;
    update();
    Response response = await couponRepo.addNewCoupon(coupon, update: isUpdate);

    if(response.statusCode == 200){
      getCouponList(1);
      Get.back();
      showCustomSnackBarHelper(isUpdate? 'coupon_updated_successfully'.tr : 'coupon_added_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();

  }

  void onChangeDropdownIndex(int index, {bool isUpdate = true}){
    _dropDownPosition = index;
    if(isUpdate) {
      update();
    }
  }

  void setDate( String type, DateTime? dateTime){
    if(type == 'start'){
      _startDate = dateTime;
    }else{
      _endDate = dateTime;
    }

  }

  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
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

  void selectDate(String type, BuildContext context){
    showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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
