import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/product/domain/models/categories_product_model.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/common/reposotories/category_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;

class CategoryController extends GetxController implements GetxService{
  final CategoryRepo categoryRepo;
  CategoryController({required this.categoryRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  CategoryModel? _categoryModel;
  CategoryModel? get categoryModel => _categoryModel;

  SubCategoryModel? _subCategoryModel;
  SubCategoryModel? get subCategoryModel => _subCategoryModel;


  int? _categorySelectedIndex;
  int? get categorySelectedIndex => _categorySelectedIndex;


  int? _selectedCategoryId;
  int? _selectedSubCategoryId;
  int? get selectedCategoryId => _selectedCategoryId;
  int? get selectedSubCategoryId => _selectedSubCategoryId;



  List<CategoriesProduct>? _categoriesProductList;
  List<CategoriesProduct>? get categoriesProductList =>_categoriesProductList;

  List<Products>? _searchedProductList;
  List<Products>? get searchedProductList =>_searchedProductList;



  final picker = ImagePicker();
  XFile? _categoryImage;
  XFile? get categoryImage=> _categoryImage;

  void pickImage(bool isRemove) async {
    if(isRemove) {
      _categoryImage = null;
    }else {
      _categoryImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }



  Future<http.StreamedResponse> addCategory(String categoryName, int? categoryId, bool isUpdate) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await categoryRepo.addCategory(categoryName,categoryId, _categoryImage, Get.find<AuthController>().getUserToken(), isUpdate: isUpdate);
    if(response.statusCode == 200) {
      _categoryImage = null;
      getCategoryList(1);
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper(isUpdate? 'category_updated_successfully'.tr : 'category_added_successfully'.tr, isError: false);

    }
    else {
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }





  Future<void> getCategoryList(int offset, {Products? product, isUpdate = true, int limit = 10}) async {
    if(offset == 1){
      _categoryModel = null;

      if(isUpdate) {
        update();
      }
    }

    Response response = await categoryRepo.getCategoryList(offset, limit);

    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _categoryModel = CategoryModel.fromJson(response.body);
      }else {
        _categoryModel?.offset = CategoryModel.fromJson(response.body).offset;
        _categoryModel?.totalSize = CategoryModel.fromJson(response.body).totalSize;
        _categoryModel?.categoriesList?.addAll(CategoryModel.fromJson(response.body).categoriesList ?? []);
      }

      if(product != null && (product.categoryIds?.isNotEmpty ?? false)){
        setCategoryIndex((int.tryParse(product.categoryIds?.first.id ?? '')), false, product: product);
      }

    }else {
      ApiChecker.checkApi(response);

    }
    update();
  }


  Future<void> getCategoryWiseProductList(int? categoryId, {bool isUpdate = true}) async {
    _categoriesProductList  = null;

    if(isUpdate) {
      update();
    }

    Response response = await categoryRepo.getCategoryWiseProductList(categoryId);
    if(response.statusCode == 200 && response.body != {}) {
      _categoriesProductList = [];
      response.body.forEach((categoriesProduct) => _categoriesProductList?.add(CategoriesProduct.fromJson(categoriesProduct)));
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }



  Future<void> getSearchProductList(String name, {bool isReset = false}) async {
    if(!isReset){
      Response response = await categoryRepo.getSearchProductByName(name);
      if(response.body != {} &&  response.statusCode == 200) {
        _searchedProductList = [];
        _searchedProductList?.addAll(ProductModel.fromJson(response.body).products ?? []);
      }else {
        ApiChecker.checkApi(response);
      }
      update();

    }else{
      _searchedProductList = null;
      update();
    }
  }




  Future<void> getSubCategoryList(int offset, int? categoryId, {Products? product, bool isUpdate = true}) async {
    
    _selectedCategoryId = categoryId;

    if(offset == 1){
      _subCategoryModel = null;

      if(isUpdate){
        update();
      }
    }

    Response response = await categoryRepo.getSubCategoryList(offset, categoryId);
    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _subCategoryModel = SubCategoryModel.fromJson(response.body);
      }else {
        _subCategoryModel?.offset = SubCategoryModel.fromJson(response.body).offset;
        _subCategoryModel?.totalSize = SubCategoryModel.fromJson(response.body).totalSize;
        _subCategoryModel?.subCategoriesList?.addAll(SubCategoryModel.fromJson(response.body).subCategoriesList ?? []);
      }

      if(product != null && product.categoryIds != null){
        for(int i = 0; i < (product.categoryIds?.length ?? 0); i++) {
          if(product.categoryIds?[i].position == 2) {
            setSubCategoryIndex(int.tryParse('${product.categoryIds?[i].id}'), false);
          }
        }
      }

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> addSubCategory(String subCategoryName, int? id, int? parenCategoryId, bool isUpdate) async {
    _isLoading = true;
    update();
    Response response = await categoryRepo.addSubCategory(subCategoryName, parenCategoryId,id, isUpdate: isUpdate);
    if(response.statusCode == 200) {
      getSubCategoryList(1, parenCategoryId);
      Get.back();
      showCustomSnackBarHelper(isUpdate ? 'sub_category_update_successfully'.tr : 'sub_category_added_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }


  void setCategoryIndex(int? id, bool notify, {bool fromUpdate = false, Products? product}) {
    _selectedSubCategoryId = null;

    if(id != null){
      getSubCategoryList(1, id, product: product);

    }else{
      _subCategoryModel = null;
    }

    _selectedCategoryId =  id;
    _categorySelectedIndex = _selectedCategoryId;
    if(notify) {
      update();
    }
  }
  void setSubCategoryIndex(int? index, bool notify) {
    _selectedSubCategoryId = index;

    if(notify) {
      update();
    }
  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
  }


  Future<void> deleteCategory(int? categoryId) async {
    Response response = await categoryRepo.deleteCategory(categoryId);
    if(response.statusCode == 200) {
      getCategoryList(1);
      Get.back();
      showCustomSnackBarHelper('category_deleted_successfully'.tr, isError: false);
    }else {
      Get.back();
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> deleteSubCategory(SubCategories subCategory) async {
    _isLoading = true;
    update();
    Get.back();

    Response response = await categoryRepo.deleteCategory(subCategory.id);
    if(response.statusCode == 200) {
      getSubCategoryList(1, subCategory.parentId);
      showCustomSnackBarHelper('sub_category_deleted_successfully'.tr, isError: false);

    }else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> onChangeCategoryStatus(int? categoryId, int status, int? index) async {
    Response response = await categoryRepo.updateCategoryStatus(categoryId, status);
    if(response.statusCode == 200){
      _categoryModel?.categoriesList?[index!].status = status;
      showCustomSnackBarHelper('category_status_updated_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> onChangeSubCategoryStatus(int subCategoryId, int status) async {
    Response response = await categoryRepo.updateCategoryStatus(subCategoryId, status);
    if(response.statusCode == 200){
      getSubCategoryList(1, categorySelectedIndex);
      showCustomSnackBarHelper('category_status_updated_successfully'.tr, isError: false);
    }else{
      ApiChecker.checkApi(response);
    }
    update();
  }


  void setCategoryAndSubCategoryEmpty(){
    _selectedCategoryId = null;
    _selectedSubCategoryId = null;
  }

}