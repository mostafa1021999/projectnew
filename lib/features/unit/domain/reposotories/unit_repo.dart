import 'package:get/get.dart';
import 'package:six_pos/data/api/api_client.dart';
import 'package:six_pos/util/app_constants.dart';



class UnitRepo{
  ApiClient apiClient;
  UnitRepo({required this.apiClient});

  Future<Response> getUnitList(int offset, int limit) async {
    return await apiClient.getData('${AppConstants.getUnitList}?limit=$limit&offset=$offset');
  }

  Future<Response> deleteUnit(int? unitId) async {
    return await apiClient.getData('${AppConstants.deleteUnitUri}?id=$unitId  ');
  }

  Future<Response> addUnit(String unitType, int? unitId, {bool isUpdate = false}) async {
    return await apiClient.postData(isUpdate? AppConstants.updateUnitUri: AppConstants.addUnitUri,
        {
          'id': unitId,
          'unit_type': unitType,
          '_method': isUpdate? 'put' :'post'
        });
  }


}