import 'package:image_picker/image_picker.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:six_pos/common/models/profile_model.dart';
import 'package:six_pos/features/shop/domain/reposotories/profile_repo.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/splash/domain/models/revenue_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileRepo profileRepo;
  ProfileController({required this.profileRepo});

  bool _firstTimeConnectionCheck = true;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  ProfileModel? _profileModel;
  ProfileModel? get profileModel=>  _profileModel;

  RevenueSummary? _revenueModel;
  RevenueSummary? get revenueModel=>  _revenueModel;

  int _revenueFilterTypeIndex = 0;
  int get revenueFilterTypeIndex => _revenueFilterTypeIndex;

  String? _revenueFilterType = '';
  String? get revenueFilterType => _revenueFilterType;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<dynamic> _timeZoneList =[];
  List<dynamic> get timeZoneList => _timeZoneList;
  List<String> _timeZone =[];
  List<String> get timeZone => _timeZone;

  String? _selectedTimeZone = '';
  String? get selectedTimeZone => _selectedTimeZone;

  ModulePermission? _modulePermission;
  ModulePermission? get modulePermission => _modulePermission;



  void getTimeZoneList() async {
    _timeZone = Get.find<SplashController>().configModel?.timeZone ?? [];
  }



  Future<void> getProfileData() async {
    final List<String> adminModulePermissionList = Get.find<SplashController>().configModel?.permissionModule ?? [];

    Response response = await profileRepo.getProfile();
    if(response.statusCode == 200) {
      _profileModel = ProfileModel.fromJson(response.body);

      _modulePermission = _getModulePermission(_profileModel?.role?.modules ?? adminModulePermissionList);


    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  ModulePermission _getModulePermission(List<String> moduleList) {
    return ModulePermission(
      pos: moduleList.contains('pos_section'),
      product: moduleList.contains('product_section'),
      employee: moduleList.contains('employee_section'),
      customer: moduleList.contains('customer_section'),
      supplier: moduleList.contains('supplier_section'),
      setting: moduleList.contains('setting_section'),
      account: moduleList.contains('account_section'),
      brand: moduleList.contains('brand_section'),
      category: moduleList.contains('category_section'),
      coupon: moduleList.contains('coupon_section'),
      employeeRole: moduleList.contains('employee_role_section'),
      limitedStock: moduleList.contains('stock_section'),
      unit: moduleList.contains('unit_section'),
      dashboard: moduleList.contains('dashboard_section'),

    );
  }

  Future<void> getDashboardRevenueData(String? filterType) async {
    Response response = await profileRepo.getDashboardRevenueSummery(filterType);
    if(response.statusCode == 200) {
      _revenueModel = RevenueModel.fromJson(response.body).revenueSummary;
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }


  void setRevenueFilterType(int index, bool notify) {
    _revenueFilterTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void setRevenueFilterName(String? filterName, bool notify) {
    _revenueFilterType = filterName;
    getDashboardRevenueData(filterName);
    if(notify) {
      update();
    }
  }

  final picker = ImagePicker();
  XFile? _shopLogo;
  XFile? get shopLogo=> _shopLogo;
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _shopLogo = null;
    }else {
      _shopLogo = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  Future<http.StreamedResponse> updateShop(BusinessInfo shop) async {

    _isLoading = true;
    update();
    http.StreamedResponse response = await profileRepo.updateShop(shop, _shopLogo, Get.find<AuthController>().getUserToken());
    if(response.statusCode == 200) {
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper('shop_updated_successfully'.tr, isError: false);
    }else {
      _isLoading = false;
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }

  void setValueForSelectedTimeZone (String? setValue){
    _selectedTimeZone = setValue;
  }
}
