import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/features/product_setup/widgets/product_general_info_widget.dart';
import 'package:six_pos/features/product_setup/widgets/product_price_info_widget.dart';

class AddProductScreen extends StatefulWidget {
  final Products? product;
  final int? supplierId;
  const AddProductScreen({Key? key, this.product, this.supplierId}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> with TickerProviderStateMixin{
  TabController? _tabController;
  int selectedIndex = 0;
  late bool update;

  Future<void> _loadData() async {
    Get.find<CategoryController>().getCategoryList(1, product: widget.product, isUpdate: false, limit: 100);
    Get.find<BrandController>().getBrandList(1, product: widget.product, isUpdate: false, limit: 100);
    Get.find<UnitController>().getUnitList(1,  product: widget.product, limit: 100);
    Get.find<SupplierController>().getSupplierList(1,  product: widget.product,isUpdate: false, limit: 100);
  }

  @override
  void initState() {
    super.initState();

    final productController =  Get.find<ProductController>();

    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    _tabController?.addListener(() {
      if(_tabController != null &&  !_tabController!.indexIsChanging){
        productController.setIndexForTabBar(_tabController!.index);
      }
    });

    update = widget.product != null;
    productController.setIndexForTabBar(0, isUpdate: false);
    _loadData();

    if(update){
      productController.productSellingPriceController.text = widget.product!.sellingPrice.toString();
      productController.productPurchasePriceController.text = widget.product!.purchasePrice.toString();
      productController.productTaxController.text = widget.product!.tax.toString();
      productController.productDiscountController.text = widget.product!.discount.toString();
      productController.productSkuController.text = widget.product!.productCode!;
      productController.productStockController.text = widget.product!.quantity.toString();
      productController.productNameController.text = widget.product!.title!;
      productController.unitValueController.text = widget.product!.unitValue.toString();

    }else{
      productController.productSellingPriceController.clear();
      productController.productPurchasePriceController.clear();
      productController.productTaxController.clear();
      productController.productDiscountController.clear();
      productController.productSkuController.clear();
      productController.productStockController.clear();
      productController.productNameController.clear();
      productController.unitValueController.clear();

      Get.find<BrandController>().onChangeBrandId(null, true);
      Get.find<CategoryController>().setCategoryAndSubCategoryEmpty();
      Get.find<UnitController>().setUnitEmpty();


    }

    if(widget.supplierId != null) {
      Get.find<SupplierController>().setSupplierIndex(widget.supplierId, false);
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer: const CustomDrawerWidget(),

      appBar: const CustomAppBarWidget(),

      body: Column( children: [
        CustomHeaderWidget(title: update ? 'update_product'.tr : 'add_product'.tr, headerImage: Images.addNewCategory),

        Center(
          child: Container(
            width: 1170,
            color: Theme.of(context).cardColor,
            child: TabBar(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
              controller: _tabController,
              labelColor: Theme.of(context).secondaryHeaderColor,
              unselectedLabelColor: Theme.of(context).primaryColor,
              indicatorColor: Theme.of(context).secondaryHeaderColor,
              indicatorWeight: 3,
              unselectedLabelStyle: fontSizeRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w400,
              ),
              labelStyle: fontSizeRegular.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w700,
              ),
              tabs: [
                Tab(text: 'general_info'.tr),
                Tab(text: 'price_info'.tr),
              ],
            ),
          ),
        ),

        Expanded(child: TabBarView(
          controller: _tabController,
          children: [
            ProductGeneralInfoWidget(product: widget.product),
            const ProductPriceInfoWidget(),
          ],
        )),
      ]),

      bottomNavigationBar:
      GetBuilder<ProductController>(
        builder: (productController) {
          return Container(height: 70,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor
            ),
            child: productController.selectionTabIndex == 0 ?
            CustomButtonWidget(buttonText: 'next'.tr,onPressed: (){
              _tabController!.animateTo((_tabController!.index + 1) % 2);
              selectedIndex = _tabController!.index + 1;
              productController.setIndexForTabBar(selectedIndex);
            },):Row(children: [
              Expanded(
                child: CustomButtonWidget(
                  buttonColor: Theme.of(context).hintColor,
                  buttonText: 'back'.tr,onPressed: (){
                  _tabController!.animateTo((_tabController!.index + 1) % 2);
                  selectedIndex = _tabController!.index + 1;
                  productController.setIndexForTabBar(selectedIndex);
                },),
              ),
              const SizedBox(width: Dimensions.paddingSizeDefault),



              GetBuilder<CategoryController>(builder: (categoryController) {
                return Expanded(child: CustomButtonWidget(
                  isLoading: productController.isLoading,
                  buttonText: update ? 'update'.tr : 'save'.tr,
                  onPressed: (){
                    String  sellingPrice =  productController.productSellingPriceController.text.trim();
                    String  purchasePrice =  productController.productPurchasePriceController.text.trim();
                    String  tax =  productController.productTaxController.text.trim();
                    String  discount =  productController.productDiscountController.text.trim();


                    String unitId = Get.find<UnitController>().unitIndex.toString();
                    int? brandId = Get.find<BrandController>().selectedBranchId;
                    int? supplierId = Get.find<SupplierController>().selectedSupplierId;
                    String productName = productController.productNameController.text.trim();
                    String productCode = productController.productSkuController.text.trim();
                    String unitValue = productController.unitValueController.text.trim();
                    int productQuantity = 0;

                    if(productController.productStockController.text.trim().isNotEmpty){
                      productQuantity = int.parse(productController.productStockController.text.trim());
                    }
                    String? selectedDiscountType = productController.selectedDiscountType;

                    if(productName.isEmpty){
                      showCustomSnackBarHelper('product_name_required'.tr);
                    }else if(categoryController.selectedCategoryId == null){
                      showCustomSnackBarHelper('please_select_a_category'.tr);
                    }else if(Get.find<UnitController>().unitIndex == 0){
                      showCustomSnackBarHelper('please_select_unit'.tr);
                    }else if(unitValue.isEmpty){
                      showCustomSnackBarHelper('unit_value_required'.tr);
                    } else if(productCode.isEmpty){
                      showCustomSnackBarHelper('sku_required'.tr);
                    } else if(productQuantity < 1){
                      showCustomSnackBarHelper('stock_quantity_required'.tr);
                    } else if(sellingPrice.isEmpty){
                      showCustomSnackBarHelper('selling_price_required'.tr);
                    }else if(purchasePrice.isEmpty){
                      showCustomSnackBarHelper('purchase_price_required'.tr);
                    }else if(discount.isEmpty){
                      showCustomSnackBarHelper('discount_price_required'.tr);
                    }else if(tax.isEmpty){
                      showCustomSnackBarHelper('tax_price_required'.tr);
                    }else{
                      Products product = Products(
                          id: update? widget.product!.id : null,
                          title: productName,
                          sellingPrice:  double.parse(sellingPrice),
                          purchasePrice: double.parse(purchasePrice),
                          tax: double.parse(tax),
                          discount: double.parse(discount),
                          discountType: selectedDiscountType,
                          unitType: int.parse(unitId),
                          productCode: productCode,
                          quantity: productQuantity,
                          unitValue: unitValue
                      );
                      productController.addProduct(product, '${categoryController.selectedCategoryId}' , categoryController.selectedSubCategoryId.toString(), brandId, supplierId, update);
                    }
                  },));
              }),

            ],),
          );
        }
      ),
    );
  }
}

