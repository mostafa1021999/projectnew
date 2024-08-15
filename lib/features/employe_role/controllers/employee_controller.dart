import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/employe_role/domain/models/employee_model.dart';
import 'package:six_pos/features/employe_role/domain/reposotories/employee_role_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;

class EmployeeController extends GetxController implements GetxService{
  final EmployeeRoleRepo employeeRoleRepo;
  EmployeeController({required this.employeeRoleRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  final picker = ImagePicker();
  XFile? _employeeImage;
  XFile? get employeeImage=> _employeeImage;
  int? _selectRoleId;
  int? get selectRoleId => _selectRoleId;
  EmployeeModel? _employeeModel;
  EmployeeModel? get employeeModel => _employeeModel;

  void pickImage(bool isRemove, {bool isUpdate = true}) async {
    if(isRemove) {
      _employeeImage = null;
    }else {
      try{
        _employeeImage = await ImagePicker().pickImage(source: ImageSource.gallery);

      }catch(e) {
        _employeeImage = null;
      }
    }
    if(isUpdate) {
      update();
    }
  }

  void onChangeRoleId(int? id, {bool isUpdate = true}) {
    _selectRoleId = id;

    if(isUpdate) {
      update();
    }
  }

  Future<void> getEmployeeList( int offset, {bool isUpdate = true}) async {

    if(offset == 1) {
      _employeeModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await employeeRoleRepo.getEmployeeList(offset);
    if(response.statusCode == 200 && response.body != null) {

      if(offset == 1) {
        _employeeModel = EmployeeModel.fromMap(response.body);
      }else{

        _employeeModel?.offset = EmployeeModel.fromMap(response.body).offset;
        _employeeModel?.totalSize = EmployeeModel.fromMap(response.body).totalSize;
        _employeeModel?.employees?.addAll(EmployeeModel.fromMap(response.body).employees ?? []);
      }

    }else {
      ApiChecker.checkApi(response);
    }

    update();
  }



  Future<http.StreamedResponse> addEmployee(Employee employee, bool isUpdate) async {

    _isLoading = true;
    update();
    http.StreamedResponse response = await employeeRoleRepo.addEmployee(employee, _employeeImage,  Get.find<AuthController>().getUserToken(), isUpdate: isUpdate);

    if(response.statusCode == 200) {
      getEmployeeList(1);
      Get.back();
      showCustomSnackBarHelper(isUpdate? 'employee_updated_successfully'.tr : 'employee_added_successfully'.tr, isError: false);

    }else {
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> deleteEmployeeById(int? id) async {
    _isLoading = true;
    update();
    Response response = await employeeRoleRepo.deleteEmployee(id);

    if(response.statusCode == 200 && response.body != null){

      await getEmployeeList(1);
      Get.back();


      showCustomSnackBarHelper('employee_deleted_successfully'.tr, isError: false);
    }else{
      Get.back();
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();

  }








}