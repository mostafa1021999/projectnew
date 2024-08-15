import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/account_management/domain/models/expense_model.dart';
import 'package:six_pos/features/account_management/domain/reposotories/expense_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';

class ExpenseController extends GetxController implements GetxService{
  final ExpenseRepo expenseRepo;
  ExpenseController({required this.expenseRepo});
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  ExpenseModel? _expenseModel;
  ExpenseModel? get expenseModel => _expenseModel;

  Future<void> getExpenseList( int offset, {bool isUpdate = true}) async {
    if(offset == 1){
      _expenseModel = null;

      if(isUpdate) {
        update();
      }

    }
    Response response = await expenseRepo.getExpenseList(offset);

    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _expenseModel = ExpenseModel.fromJson(response.body);
      }else {
        _expenseModel?.offset = ExpenseModel.fromJson(response.body).offset;
        _expenseModel?.totalSize = ExpenseModel.fromJson(response.body).totalSize;
        _expenseModel?.expensesList?.addAll(ExpenseModel.fromJson(response.body).expensesList ?? []);
      }

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getExpenseFilter(String startDate, String endDate) async {
    _expenseModel = null;
    update();
    Response response = await expenseRepo.getExpenseFilter(startDate, endDate);

    if(response.statusCode == 200) {
      _expenseModel = ExpenseModel.fromJson(response.body);

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> deleteExpense(int expenseId) async {
    _isLoading = true;
    update();

    Response response = await expenseRepo.deleteExpense(expenseId);
    if(response.statusCode == 200) {
      await getExpenseList(1);
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper('expense_deleted_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> addExpense(Expenses expense , bool isUpdate) async {
    _isLoading = true;
    update();

    Response response = await expenseRepo.addNewExpense(expense, isUpdate: isUpdate);
    if(response.statusCode == 200) {
      await getExpenseList(1);
      Get.back();
      showCustomSnackBarHelper(isUpdate? 'expense_updated_successfully'.tr : 'expense_created_successfully'.tr, isError: false);
      _isLoading = false;
    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  DateTime? _startDate;
  DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  DateFormat get dateFormat => _dateFormat;

 void clearDatePicker() {
   _startDate = null;
   _endDate = null;
 }


  void selectDate(String type, {DateTime? disableBeforeDate}){
    showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: disableBeforeDate ?? DateTime(DateTime.now().year - 10),
      lastDate: type == 'start' ? DateTime.now() : DateTime(DateTime.now().year + 10),
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