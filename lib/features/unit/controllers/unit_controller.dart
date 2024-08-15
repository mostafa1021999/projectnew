import 'package:get/get.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';
import 'package:six_pos/features/unit/domain/reposotories/unit_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';

class UnitController extends GetxController implements GetxService{
  final UnitRepo unitRepo;
  UnitController({required this.unitRepo});
  bool _isLoading = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isLoading => _isLoading;
  int? _unitListLength;
  int? get unitListLength => _unitListLength;
  List<Units>? _unitList = [];
  List<Units>? get unitList =>_unitList;
  int? _unitIndex = 0;
  int? get unitIndex => _unitIndex;
  List<int?> _unitIds = [];
  List<int?> get unitIds => _unitIds;



  Future<void> getUnitList(int offset, {Products? product, int limit = 10}) async {
    _isLoading = true;
    _unitIndex = 0;
    _unitIds = [];
    _unitIds.add(0);
    if(offset == 1){
      _unitList = null;
    }
    Response response = await unitRepo.getUnitList(offset, limit);
    if(response.statusCode == 200) {
     _unitList ??= [];
      _unitList?.addAll(UnitModel.fromJson(response.body).units!);
      _unitListLength = UnitModel.fromJson(response.body).total;

      _unitIndex = 0;
      if(_unitList != null){
        for(int index = 0; index < _unitList!.length; index++) {
          _unitIds.add(_unitList![index].id);
        }
      }

      if(product != null){
        setUnitIndex(product.unitType, false);
      }
      _isLoading = false;
      _isFirst = false;
    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }
  Future<void> deleteUnit(int? unitId) async {
    _isLoading = true;
    update();
    Response response = await unitRepo.deleteUnit(unitId);
    if(response.statusCode == 200) {
      getUnitList(1);
      Get.back();
      showCustomSnackBarHelper('unit_deleted_successfully'.tr, isError: false);
      _isLoading = false;

    }else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }
    update();
  }



  Future<void> addUnit(String unitName, int? unitId, bool isUpdate) async {

    _isLoading = true;
    update();

    Response response = await unitRepo.addUnit(unitName, unitId, isUpdate: isUpdate );
    if(response.statusCode == 200) {
      getUnitList(1);
      Get.back();
      showCustomSnackBarHelper(isUpdate? 'unit_updated_successfully'.tr : 'unit_added_successfully'.tr, isError: false);
      _isLoading = false;
    }else if(response.statusCode == 403){
      showCustomSnackBarHelper('unit_already_exist'.tr);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void removeFirstLoading() {
    _isFirst = true;
    update();
  }
  void setUnitIndex(int? index, bool notify) {
    _unitIndex = index;
    if(notify) {
      update();
    }
  }
  void setUnitEmpty(){
    _unitIndex = 0;
    update();
  }

}