import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/features/employe_role/domain/models/employee_model.dart';
import 'package:six_pos/util/app_constants.dart';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;


class EmployeeRoleRepo extends GetxService{
  ApiClient apiClient;
  EmployeeRoleRepo({required this.apiClient});

  Future<Response> getRoleList(int offset) async {
    return await apiClient.getData('${AppConstants.roleListUrl}?limit=10&offset=$offset');
  }

  Future<Response> getEmployeeList(int offset) async {
    return await apiClient.getData('${AppConstants.employeeListUrl}?limit=10&offset=$offset');
  }

  Future<Response> addRole({required List<String> moduleList, required String roleName, int? id}) async {

    Map<String, dynamic> fields = {};
    fields.addAll(<String, dynamic>{
      'modules': moduleList,
      'name': roleName,
    });


    return await apiClient.postData(id != null ? '${AppConstants.updateRoleUrl}?id=$id' : AppConstants.addRoleUrl, fields);
  }


  Future<http.StreamedResponse> addEmployee(Employee employee, XFile? file, String token, {bool isUpdate = false}) async {
    http.MultipartRequest request = isUpdate ? http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.employeeUpdateUrl}?id=${employee.id}')) :
    http.MultipartRequest('POST', Uri.parse('${AppConstants.baseUrl}${AppConstants.addEmployeeUrl}'));
    request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});

    if(file != null) {
      Uint8List list = await file.readAsBytes();
      var part = http.MultipartFile('image', file.readAsBytes().asStream(), list.length, filename: basename(file.path));
      request.files.add(part);
    }

    Map<String, String> fields = {};
    fields.addAll(<String, String>{
      'f_name': employee.fName ?? '',
      'l_name': employee.lName ?? '',
      'phone': employee.phone ?? '',
      'email': employee.email ?? '',
      'role_id': '${employee.roleId}',
    });

    if(employee.password?.isNotEmpty ?? false) {
      fields.addAll({'password': '${employee.password}'});
    }
    request.fields.addAll(fields);
    http.StreamedResponse response = await request.send();
    return response;
  }

  Future<Response> deleteRole(int? roleId) async {
    return await apiClient.getData('${AppConstants.roleDeleteUrl}?id=$roleId');
  }

  Future<Response> deleteEmployee(int? employeeId) async {
    return await apiClient.getData('${AppConstants.deleteEmployeeUrl}?id=$employeeId');
  }


}