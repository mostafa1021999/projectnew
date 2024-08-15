import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/common/models/account_model.dart';
import 'package:six_pos/common/models/earning_statistics_model.dart';
import 'package:six_pos/common/reposotories/account_repo.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';

class AccountController extends GetxController implements GetxService{
  final AccountRepo accountRepo;
  AccountController({required this.accountRepo});
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? _accountListLength;
  int? get accountListLength => _accountListLength;
  // List<Accounts> _accountList = [];
  // List<Accounts> get accountList =>_accountList;
  AccountModel? _accountModel;
  AccountModel? get accountModel => _accountModel;

  double _mmE = 0;
  double get mmE=>_mmE;
  double _mmI = 0;
  double get mmI => _mmI;
  double _maxValueForChard = 0;
  double get maxValueForChard=>_maxValueForChard;


  List <YearWiseExpense> _yearWiseExpenseList =[];
  List <YearWiseExpense> get yearWiseExpenseList => _yearWiseExpenseList;
  List <YearWiseIncome> _yearWiseIncomeList =[];
  List <YearWiseIncome> get yearWiseIncomeList => _yearWiseIncomeList;

  final List <YearWiseExpense> _filterExpenseList =[];
  List <YearWiseExpense> get filterExpenseList => _filterExpenseList;

   List<double> _expanseList = [0,0,0,0,0,0,0,0,0,0,0,0];
   List<double> get expanseList => _expanseList;

  List<double> _incomeList = [0,0,0,0,0,0,0,0,0,0,0,0];
  List<double> get incomeList => _incomeList;


  List<FlSpot> _expanseChartList = [];
  List<FlSpot> get expanseChartList =>_expanseChartList;
  List<FlSpot> _incomeChartList = [];
  List<FlSpot> get incomeChartList => _incomeChartList;

  int? _selectedAccountId;
  int? get selectedAccountId => _selectedAccountId;

  // List<int?> _accountIds = [];
  // List<int?> get accountIds => _accountIds;

  List<int> _incomeMonthList = [];
  List<int> get incomeMonthList => _incomeMonthList;

  List<int> _expenseMonthList = [];
  List<int> get expenseMonthList => _expenseMonthList;






  Future<void> getAccountList( int offset, {bool isUpdate = true}) async {
    if(offset == 1){
      _accountModel = null;
      if(isUpdate) {
        update();
      }
    }

    Response response = await accountRepo.getAccountList(offset);
    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _accountModel = AccountModel.fromJson(response.body);
      }else {
        _accountModel?.offset = AccountModel.fromJson(response.body).offset;
        _accountModel?.totalSize = AccountModel.fromJson(response.body).totalSize;
        _accountModel?.accountList?.addAll(AccountModel.fromJson(response.body).accountList ?? []);

      }
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> onSearchAccount(String search) async {
    if(search.isNotEmpty) {
      _accountModel = null;
      update();
      Response response = await accountRepo.searchAccount(search);

      if(response.statusCode == 200 && response.body != null) {
        _accountModel = AccountModel.fromJson(response.body);
      }else {
        ApiChecker.checkApi(response);
      }

      update();
    }else {
     await getAccountList(1);
    }
  }




  Future<void> deleteAccount(int? accountId) async {
    _isLoading = true;
    update();
    Response response = await accountRepo.deleteAccountId(accountId);

    if(response.statusCode == 200) {
      getAccountList(1);
      Get.back();


      showCustomSnackBarHelper('account_deleted_successfully'.tr, isError: false);
    }else {

      Get.back();
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }

  Future<void> addAccount(Accounts account, bool isUpdate) async {
    _isLoading = true;
    update();

    Response response = await accountRepo.addAccount(account, isUpdate: isUpdate);
    if(response.statusCode == 200) {
      getAccountList(1);
      Get.back();
      showCustomSnackBarHelper(isUpdate ? 'account_updated_successfully'.tr : 'account_created_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  Future<void> getRevenueDataForChart() async {
    final DateTime currentDateTime = Get.find<SplashController>().currentTime;

    _yearWiseExpenseList = [];
    _yearWiseIncomeList = [];
    _incomeMonthList =[];
    _expenseMonthList = [];
    Response response = await accountRepo.getRevenueChartData();
    if(response.statusCode == 200) {
     _yearWiseExpenseList = [];
     _yearWiseIncomeList = [];
     _expanseChartList = [];
     _incomeChartList = [];
     _yearWiseExpenseList.addAll(RevenueChartModel.fromJson(response.body).yearWiseExpense!);
     _yearWiseIncomeList.addAll(RevenueChartModel.fromJson(response.body).yearWiseIncome!);


     _expanseList = [];
     _incomeList = [];
     for(int i= 0; i<= 12; i++){
       _expanseList.add(0);
       _incomeList.add(0);
     }

     for(int i = 0; i< yearWiseExpenseList.length; i++){
       if(yearWiseExpenseList[i].month != null && yearWiseExpenseList[i].year == currentDateTime.year){
         _expanseList[yearWiseExpenseList[i].month!] = double.parse(yearWiseExpenseList[i].totalAmount!.toStringAsFixed(2));
       }
     }

     for(int i = 0; i< yearWiseIncomeList.length; i++){

       if(yearWiseIncomeList[i].month != null && yearWiseIncomeList[i].year == currentDateTime.year) {
         _incomeList[yearWiseIncomeList[i].month!] = double.parse(yearWiseIncomeList[i].totalAmount!.toStringAsFixed(2));
       }
     }

     _expanseChartList = _expanseList.asMap().entries.map((e) {
       return FlSpot(e.key.toDouble(), e.value);
     }).toList();

     _incomeChartList = _incomeList.asMap().entries.map((e) {
       return FlSpot(e.key.toDouble(), e.value);
     }).toList();

     _expanseList.sort();
     _incomeList.sort();

     _mmE = _expanseList[_expanseList.length-1];
     _mmI = _incomeList[_incomeList.length-1];
      _maxValueForChard = _mmE> _mmI? _mmE : _mmI;

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void onFilterByYear(int year){
    for(int i =0; i< _yearWiseExpenseList.length; i++){
      if(_yearWiseExpenseList[i].year ==year){
        _filterExpenseList.add(_yearWiseExpenseList[i]);
      }
    }
  }

  void setAccountIndex(int? index, bool notify) {
    _selectedAccountId = index;
    if(notify) {
      update();
    }
  }


}