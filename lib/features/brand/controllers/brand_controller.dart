import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/features/brand/domain/reposotories/brand_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;

class BrandController extends GetxController implements GetxService{
  final BrandRepo brandRepo;
  BrandController({required this.brandRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int? _brandListLength;
  int? get brandListLength => _brandListLength;
  BrandModel? _brandModel;
  BrandModel? get brandModel => _brandModel;
  int? _selectedBranchId;
  int? get selectedBranchId => _selectedBranchId;
  XFile? _brandImage;
  XFile? get brandImage=> _brandImage;

  void pickImage(bool isRemove) async {
    if(isRemove) {
      _brandImage = null;
    }else {
      _brandImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }

  Future<http.StreamedResponse> addBrand(String brandName, int? brandId) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await brandRepo.addBrand(
      brandName,brandId, _brandImage,
      Get.find<AuthController>().getUserToken(),
      isUpdate: brandId != null,
    );

    if(response.statusCode == 200) {
      _brandImage = null;
      await getBrandList(1);
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper(brandId != null ? 'brand_updated_successfully'.tr : 'brand_added_successfully'.tr, isError: false);
      _brandImage = null;

    }else {
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> getBrandList(int offset, {Products? product, bool isUpdate = true, int limit = 10}) async {

    if(offset == 1) {
      _brandModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await brandRepo.getBrandList(offset, limit);

    if(response.statusCode == 200 && response.body != null) {

      if(offset == 1) {
        _brandModel = BrandModel.fromJson(response.body);

      }else {
        _brandModel?.offset = BrandModel.fromJson(response.body).offset;
        _brandModel?.totalSize = BrandModel.fromJson(response.body).totalSize;
        _brandModel?.brandList?.addAll(BrandModel.fromJson(response.body).brandList ?? []);
      }

      if(product != null){
        onChangeBrandId(product.brand!.id, false);
      }

    }else {
      ApiChecker.checkApi(response);
    }

    update();
  }

  Future<void> deleteBrand(int? brandId) async {
    _isLoading = true;
    Response response = await brandRepo.deleteBrand(brandId);
    if(response.statusCode == 200) {
      getBrandList(1);
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper('brand_deleted_successfully'.tr, isError: false);

    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void removeImage(){
    _brandImage = null;
    update();
  }



  void onChangeBrandId(int? index, bool notify) {
    _selectedBranchId = index;
    if(notify) {
      update();
    }
  }

}