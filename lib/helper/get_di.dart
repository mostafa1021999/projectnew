
import 'dart:convert';
import 'package:six_pos/common/controllers/account_controller.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/features/coupon/controllers/coupon_controller.dart';
import 'package:six_pos/features/employe_role/controllers/employee_controller.dart';
import 'package:six_pos/features/employe_role/controllers/employee_role_controller.dart';
import 'package:six_pos/features/employe_role/domain/reposotories/employee_role_repo.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/features/shop/domain/reposotories/profile_repo.dart';
import 'package:six_pos/features/user/controllers/customer_controller.dart';
import 'package:six_pos/features/account_management/controllers/expense_controller.dart';
import 'package:six_pos/features/account_management/controllers/income_controller.dart';
import 'package:six_pos/features/langulage/controllers/language_controller.dart';
import 'package:six_pos/features/langulage/controllers/localization_controller.dart';
import 'package:six_pos/features/dashboard/controllers/menu_controller.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/common/controllers/theme_controller.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/common/reposotories/account_repo.dart';
import 'package:six_pos/features/auth/domain/reposotories/auth_repo.dart';
import 'package:six_pos/features/brand/domain/reposotories/brand_repo.dart';
import 'package:six_pos/common/reposotories/cart_repo.dart';
import 'package:six_pos/common/reposotories/category_repo.dart';
import 'package:six_pos/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:six_pos/features/user/domain/reposotories/customer_repo.dart';
import 'package:six_pos/features/account_management/domain/reposotories/expense_repo.dart';
import 'package:six_pos/features/account_management/domain/reposotories/income_repo.dart';
import 'package:six_pos/features/langulage/domain/reposotories/language_repo.dart';
import 'package:six_pos/features/order/domain/reposotories/order_repo.dart';
import 'package:six_pos/features/product/domain/reposotories/product_repo.dart';
import 'package:six_pos/features/splash/domain/reposotories/splash_repo.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/features/user/domain/reposotories/supplier_repo.dart';
import 'package:six_pos/features/account_management/domain/reposotories/transaction_repo.dart';
import 'package:six_pos/features/unit/domain/reposotories/unit_repo.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/features/langulage/domain/models/language_model.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => LanguageRepo());
  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => OrderRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
  Get.lazyPut(() => UnitRepo(apiClient: Get.find()));
  Get.lazyPut(() => BrandRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => SupplierRepo(apiClient: Get.find()));
  Get.lazyPut(() => AccountRepo(apiClient: Get.find()));
  Get.lazyPut(() => ExpenseRepo(apiClient: Get.find()));
  Get.lazyPut(() => CustomerRepo(apiClient: Get.find()));
  Get.lazyPut(() => CouponRepo(apiClient: Get.find()));
  Get.lazyPut(() => CartRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => TransactionRepo(apiClient: Get.find()));
  Get.lazyPut(() => IncomeRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProfileRepo(apiClient: Get.find()));
  Get.lazyPut(() => EmployeeRoleRepo(apiClient: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => LanguageController(sharedPreferences: Get.find()));
  Get.lazyPut(() => BottomManuController());
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  Get.lazyPut(() => UnitController(unitRepo: Get.find()));
  Get.lazyPut(() => BrandController(brandRepo: Get.find()));
  Get.lazyPut(() => ProductController(productRepo: Get.find()));
  Get.lazyPut(() => SupplierController(supplierRepo: Get.find()));
  Get.lazyPut(() => AccountController(accountRepo: Get.find()));
  Get.lazyPut(() => ExpenseController(expenseRepo: Get.find()));
  Get.lazyPut(() => CustomerController(customerRepo: Get.find()));
  Get.lazyPut(() => CouponController(couponRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => TransactionController(transactionRepo: Get.find()));
  Get.lazyPut(() => IncomeController(incomeRepo: Get.find()));
  Get.lazyPut(() => ProfileController(profileRepo: Get.find()));
  Get.lazyPut(() => RoleController(employeeRoleRepo: Get.find()));
  Get.lazyPut(() => EmployeeController(employeeRoleRepo: Get.find()));


  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> jsonValue = {};
    mappedJson.forEach((key, value) {
      jsonValue[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = jsonValue;
  }
  return languages;
}
