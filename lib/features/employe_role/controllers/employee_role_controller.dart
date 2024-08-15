import 'package:get/get.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/employe_role/domain/models/role_model.dart';
import 'package:six_pos/features/employe_role/domain/models/role_status_model.dart';
import 'package:six_pos/features/employe_role/domain/reposotories/employee_role_repo.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';

class RoleController extends GetxController implements GetxService{
  final EmployeeRoleRepo employeeRoleRepo;
  RoleController({required this.employeeRoleRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<String>? _permissionModule;
  List<String>? get permissionModule => _permissionModule;

  List<ModuleModel>? _selectedModuleList;
  List<ModuleModel>? get selectedModuleList => _selectedModuleList;

  bool? _isModuleAllSelect;
  bool? get isModuleAllSelect => _isModuleAllSelect;

  RoleModel? _roleModel;
  RoleModel? get roleModel => _roleModel;

  void initializeModuleList(RoleItemModel? role) {

    _permissionModule = Get.find<SplashController>().configModel?.permissionModule ?? [];
    _selectedModuleList = [];
    List<String> roleModuleList = [];

    for(int i = 0; i < (_permissionModule?.length ?? 0); i++) {
      _selectedModuleList?.add(ModuleModel(
        module: permissionModule![i],
        status: false,
      ));
    }

    if(role != null) {
      roleModuleList.addAll(role.modules ?? []);

      for(int i = 0; i < (_selectedModuleList?.length ?? 0); i++) {
        for(int j = 0; j < roleModuleList.length; j++) {

          if(_selectedModuleList?[i].module == roleModuleList[j]) {
            _selectedModuleList?[i].status = true;
            roleModuleList.removeAt(j);
          }
        }
      }
    }
  }

  void onChangeModuleAllSelect(bool? status, {bool isUpdate = true}) {
    if(status != null) {
      for(int i = 0; i < (_selectedModuleList?.length ?? 0); i++) {
        _selectedModuleList?[i].status = status;
      }
    }
    _isModuleAllSelect = status;

    if(isUpdate) {
      update();
    }

  }

  void onChangeModuleStatus(int index, bool status) {
    _selectedModuleList?[index].status = status;

    update();
  }






  Future<void> addOrUpdateRole(String name, int? id) async {
    _isLoading = true;
    update();
    Response response = await employeeRoleRepo.addRole(moduleList: _getModuleList(_selectedModuleList ?? []), roleName: name, id: id);

    if(response.statusCode == 200 && response.body != null){

      await getRoleList(1);
      Get.back();


      showCustomSnackBarHelper(id != null ? 'role_updated_successfully'.tr : 'role_added_successfully'.tr, isError: false);
    }else{

      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();

  }

  Future<void> deleteRoleById(int? id) async {
    _isLoading = true;
    update();
    Response response = await employeeRoleRepo.deleteRole(id);

    if(response.statusCode == 200 && response.body != null){

      await getRoleList(1);
      Get.back();

      showCustomSnackBarHelper('role_deleted_successfully'.tr, isError: false);

    }else{
      Get.back();
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();

  }

  Future<void> getRoleList( int offset, {bool isUpdate = true}) async {

    if(offset == 1) {
      _roleModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await employeeRoleRepo.getRoleList(offset);
    if(response.statusCode == 200 && response.body != null) {

      if(offset == 1) {
        _roleModel = RoleModel.fromMap(response.body);
      }else{

        _roleModel?.offset = RoleModel.fromMap(response.body).offset;
        _roleModel?.totalSize = RoleModel.fromMap(response.body).totalSize;
        _roleModel?.roleList?.addAll(RoleModel.fromMap(response.body).roleList ?? []);
      }

    }else {
      ApiChecker.checkApi(response);
    }

    update();
  }


  List<String> _getModuleList(List<ModuleModel> moduleList) {
    List<String> list = [];

    for(int i = 0; i < moduleList.length; i++) {
      if(moduleList[i].status) {
        list.add(moduleList[i].module);
      }
    }

    return list;
  }








}