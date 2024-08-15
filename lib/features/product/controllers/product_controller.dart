import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/data/api/api_checker.dart';
import 'package:six_pos/features/product/domain/models/limite_stock_product_model.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/features/product/domain/reposotories/product_repo.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;


class ProductController extends GetxController implements GetxService{
  final ProductRepo productRepo;
  ProductController({required this.productRepo});

  bool _isLoading = false;
  final bool _isSub = false;
  bool _isFirst = true;
  bool get isFirst => _isFirst;
  bool get isLoading => _isLoading;
  bool get isSub => _isSub;
  int _discountTypeIndex = 0;
  int get discountTypeIndex => _discountTypeIndex;


  ProductModel? _productModel;
  ProductModel? get productModel=> _productModel;

  LimitedStockProductModel? _limitedStockProductModel;
  LimitedStockProductModel? get limitedStockProductModel => _limitedStockProductModel;

  final TextEditingController _productNameController = TextEditingController();
  TextEditingController get productNameController => _productNameController;
  final TextEditingController _productStockController = TextEditingController();
  TextEditingController get productStockController => _productStockController;
  final TextEditingController _productSkuController = TextEditingController();
  TextEditingController get productSkuController => _productSkuController;

  final TextEditingController _unitValueController = TextEditingController();
  TextEditingController get unitValueController => _unitValueController;

  final TextEditingController _productSellingPriceController = TextEditingController();
  TextEditingController get productSellingPriceController => _productSellingPriceController;

  final TextEditingController _productPurchasePriceController = TextEditingController();
  TextEditingController get productPurchasePriceController => _productPurchasePriceController;

  final TextEditingController _productTaxController = TextEditingController();
  TextEditingController get productTaxController => _productTaxController;

  final TextEditingController _productDiscountController = TextEditingController();
  TextEditingController get productDiscountController => _productDiscountController;

  final TextEditingController _productQuantityController = TextEditingController();
  TextEditingController get productQuantityController => _productQuantityController;


  int _selectionTabIndex = 0;
  int get selectionTabIndex =>_selectionTabIndex;
  String? _selectedDiscountType = '';
  String? get selectedDiscountType =>_selectedDiscountType;

  File? _selectedFileForImport ;
  File? get selectedFileForImport =>_selectedFileForImport;

  String? _bulkImportSampleFilePath = '';
  String? get bulkImportSampleFilePath =>_bulkImportSampleFilePath;


  String? _printBarCode = '';
  String? get printBarCode =>_printBarCode;


  String? _bulkExportFilePath = '';
  String? get bulkExportFilePath =>_bulkExportFilePath;

  int _barCodeQuantity = 0;
  int get barCodeQuantity => _barCodeQuantity;
  bool _isUpdate = false;
  bool get isUpdate =>_isUpdate;




  final picker = ImagePicker();
  XFile? _productImage;
  XFile? get productImage=> _productImage;
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _productImage = null;
    }else {
      _productImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    update();
  }


  Future<void> getProductList( int offset, {bool isUpdate = true}) async {
    if(offset == 1){
      _productModel = null;

      if(isUpdate) {
        update();
      }
    }
    Response response = await productRepo.getProductList(offset);
    if(response.statusCode == 200 && response.body != null) {

      if(offset == 1) {
        _productModel = ProductModel.fromJson(response.body);

      }else {
        _productModel?.totalSize = ProductModel.fromJson(response.body).totalSize;
        _productModel?.offset = ProductModel.fromJson(response.body).offset;
        _productModel?.products?.addAll(ProductModel.fromJson(response.body).products ?? []);

      }

    }else {
      ApiChecker.checkApi(response);
    }

    update();
  }

  Future<void> getSearchProductList(String name, int offset, {bool isUpdate = true}) async {
    if(offset == 1) {
      _productModel = null;

      if(isUpdate) {
        update();
      }
    }
    Response response = await productRepo.searchProduct(name, offset);

    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _productModel = ProductModel.fromJson(response.body);

      }else {
        _productModel?.totalSize = ProductModel.fromJson(response.body).totalSize;
        _productModel?.offset = ProductModel.fromJson(response.body).offset;
        _productModel?.products?.addAll(ProductModel.fromJson(response.body).products ?? []);

      }

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> getLimitedStockProductList( int offset, {bool isUpdate = true}) async {
    if(offset == 1){
      _limitedStockProductModel = null;
      
      if(isUpdate) {
        update();
      }
    }
    Response response = await productRepo.getLimitedStockProductList(offset);
    if(response.statusCode == 200 && response.body != null) {
      
      if(offset == 1) {
        _limitedStockProductModel = LimitedStockProductModel.fromJson(response.body);
        
      }else{
        _limitedStockProductModel?.totalSize = LimitedStockProductModel.fromJson(response.body).totalSize;
        _limitedStockProductModel?.offset = LimitedStockProductModel.fromJson(response.body).offset;
        _limitedStockProductModel?.stockLimitedProducts?.addAll(LimitedStockProductModel.fromJson(response.body).stockLimitedProducts ?? []);

      }
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getSupplierProductList(int offset, int? supplierId, {bool reload = true}) async {

    if(offset == 1) {
      _productModel = null;

      if(isUpdate) {
        update();
      }
    }
    Response response = await productRepo.getSupplierProductList(offset, supplierId);

    if(response.statusCode == 200 && response.body != null) {
      if(offset == 1) {
        _productModel = ProductModel.fromJson(response.body);

      }else {
        _productModel?.totalSize = ProductModel.fromJson(response.body).totalSize;
        _productModel?.offset = ProductModel.fromJson(response.body).offset;
        _productModel?.products?.addAll(ProductModel.fromJson(response.body).products ?? []);

      }

    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<void> updateProductQuantity(int? productId, int quantity) async {
    _isUpdate = true;
    Response response = await productRepo.updateProductQuantity(productId, quantity);
    if(response.statusCode == 200) {
      _productQuantityController.clear();
      getLimitedStockProductList(1);
      getProductList(1);

      showCustomSnackBarHelper('product_quantity_updated_successfully'.tr, isError: false);
      _isUpdate = false;
    }else {
      ApiChecker.checkApi(response);
    }
    _isUpdate = false;
    update();
  }

  Future<http.StreamedResponse> addProduct(Products product, String category, String subCategory, int? brandId, int? supplierId, bool isUpdate) async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await productRepo.addProduct(product,category,subCategory,brandId,supplierId, _productImage, Get.find<AuthController>().getUserToken(), isUpdate: isUpdate);

    if(response.statusCode == 200) {
      _productImage = null;
       await getProductList(1);

      _productNameController.clear();
      _productStockController.clear();
      _productSkuController.clear();
      _productSellingPriceController.clear();
      _productPurchasePriceController.clear();
      _productTaxController.clear();
      _productDiscountController.clear();
      _productQuantityController.clear();
      Get.back();
      showCustomSnackBarHelper(isUpdate? 'product_updated_successfully'.tr : 'product_added_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }

  Future<void> deleteProduct( int? productId) async {
    update();
    Response response = await productRepo.deleteProduct(productId);
    if(response.statusCode == 200) {
      Get.back();
     getProductList(1);
     showCustomSnackBarHelper('product_deleted_successfully'.tr.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void removeImage(){
    _productImage = null;
    update();
  }


  void removeFirstLoading() {
    _isFirst = true;
    update();
  }

  void setDiscountTypeIndex(int index, bool notify) {
    _discountTypeIndex = index;
    if(notify) {
      update();
    }
  }

  void setIndexForTabBar(int index, {bool isUpdate = true}){
    _selectionTabIndex = index;
    if(isUpdate){
      update();
    }
  }

  void setSelectedDiscountType(String? type){
    _selectedDiscountType = type;
    update();
  }
  void setSelectedFileName(File fileName){
    _selectedFileForImport = fileName;
    update();
  }

  Future<void> getSampleFile() async {
    Response response = await productRepo.downloadSampleFile();
    if(response.statusCode == 200) {
      Map map = response.body;
      _bulkImportSampleFilePath = map['product_bulk_file'];
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  Future<http.StreamedResponse> bulkImportFile() async {
    _isLoading = true;
    update();
    http.StreamedResponse response = await productRepo.bulkImport(_selectedFileForImport, Get.find<AuthController>().getUserToken());
    if(response.statusCode == 200) {
      _isLoading = false;
      Get.back();
      showCustomSnackBarHelper('product_imported_successfully'.tr, isError: false);
      _selectedFileForImport = null;

    }else {
      _isLoading = false;
      ApiChecker.checkApi(await ApiChecker.getResponse(response));
    }
    _isLoading = false;
    update();
    return response;
  }




  Future<void> bulkExportFile() async {
    Response response = await productRepo.bulkExport();
    if(response.statusCode == 200) {
      Map map = response.body;
      _bulkExportFilePath = map['excel_report'];
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setBarCodeQuantity(int quantity){
    _barCodeQuantity = quantity;
    update();
  }


  void downloadFile(String url, String dir) async {
     await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      showNotification: true,
       saveInPublicStorage: true,
      openFileFromNotification: true,
    );
  }

  Future<void> barCodeDownload(int id, int quantity) async {
    Response response = await productRepo.barCodeDownLoad(id, quantity);
    if(response.statusCode == 200) {
      _printBarCode = response.body;
      showCustomSnackBarHelper('barcode_downloaded_successfully'.tr, isError: false);
    }else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  bool checkFileExtension(List<String> extensionList, String filePath) => extensionList.contains(path.extension(filePath).replaceAll('.', ''));

}