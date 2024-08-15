import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';


class ProductGeneralInfoWidget extends StatefulWidget {
  final Products? product;
  const ProductGeneralInfoWidget({Key? key, this.product}) : super(key: key);

  @override
  State<ProductGeneralInfoWidget> createState() => _ProductGeneralInfoWidgetState();
}

class _ProductGeneralInfoWidgetState extends State<ProductGeneralInfoWidget> {


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height * 0.5;
    return GetBuilder<ProductController>(
      builder: (productController) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'product_name_hint'.tr,
                        controller: productController.productNameController
                      ),
                      title: 'product_name'.tr,
                      requiredField: true,
                    ),

                    GetBuilder<BrandController>(
                        builder: (brandController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_brand'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Builder(
                                builder: (context) {
                                  return Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                        border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                                    child: DropdownButton<int>(
                                      hint: Text('select'.tr),
                                      menuMaxHeight: height,
                                      value: brandController.selectedBranchId,
                                      items: brandController.brandModel?.brandList?.map((Brands? value) {
                                        return DropdownMenuItem<int>(
                                          value: value?.id,
                                          child: Text('${value?.name}'),
                                          // child: Text( value != 0? brandController.brandModel!.brandList![(brandController.brandIds.indexOf(value) -1)].name!: 'select'.tr),
                                        );
                                      }).toList(),
                                      onChanged: (int? value) {
                                        brandController.onChangeBrandId(value, true);
                                      },
                                      isExpanded: true, underline: const SizedBox(),),);
                                }
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                            ],),
                          );
                        }
                    ),

                    GetBuilder<CategoryController>(
                        builder: (categoryController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                              Text('select_category'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                                ),
                                child: DropdownButton<int>(
                                  hint: Text('select'.tr),
                                  menuMaxHeight: height,
                                  value: categoryController.selectedCategoryId,
                                  items: categoryController.categoryModel?.categoriesList?.map((Categories? value) => DropdownMenuItem<int>(
                                    value: value?.id,
                                    child: Text(value?.name ?? ''),
                                  )).toList(),
                                  onChanged: (int? value)=> categoryController.setCategoryIndex(value!, true),
                                  isExpanded: true, underline: const SizedBox(),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                            ],),
                          );
                        }
                    ),

                    GetBuilder<CategoryController>(
                        builder: (categoryController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_sub_category'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                                child: DropdownButton<int>(
                                  menuMaxHeight: height,
                                  value: categoryController.selectedSubCategoryId,
                                  hint: Text('select'.tr),
                                  items: categoryController.subCategoryModel?.subCategoriesList?.map((SubCategories? value) {
                                    return DropdownMenuItem<int>(
                                        value: value?.id,
                                        child: Text(value?.name ?? ''));
                                  }).toList(),
                                  onChanged: (int? value) {
                                    categoryController.setSubCategoryIndex(value, true);
                                  },
                                  isExpanded: true, underline: const SizedBox(),),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                            ],),
                          );
                        }
                    ),

                    GetBuilder<UnitController>(
                        builder: (unitController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_unit'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                                child: DropdownButton<int>(
                                  value: unitController.unitIndex,
                                  items: unitController.unitIds.map((int? value) {
                                    return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value != 0?
                                        unitController.unitList![(unitController.unitIds.indexOf(value) -1)].unitType!: 'select'.tr ));}).toList(),
                                  onChanged: (int? value) {
                                    unitController.setUnitIndex(value, true);
                                  },
                                  isExpanded: true, underline: const SizedBox(),),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),


                            ],),
                          );
                        }
                    ),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'sku_hint'.tr,
                        controller: productController.unitValueController,
                        inputType: TextInputType.number,
                      ),
                      title: 'unit_value'.tr,
                      requiredField: true,
                    ),

                    CustomFieldWithTitleWidget(
                      onTap: (){
                        var rng = Random();
                        var code = rng.nextInt(900000) + 100000;
                        productController.productSkuController.text = code.toString();
                      },
                      customTextField: CustomTextFieldWidget(hintText: 'sku_hint'.tr,
                      controller: productController.productSkuController),
                      title: 'sku'.tr,
                      requiredField: true,
                    ),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'stock_quantity_hint'.tr,
                      controller: productController.productStockController,
                        inputType: TextInputType.number,
                      ),
                      title: 'stock_quantity'.tr,
                      requiredField: true,
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                      child: Text('product_image'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeSmall),


                    GetBuilder<ProductController>(
                      builder: (productController) {
                        return  Align(alignment: Alignment.center, child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            child: productController.productImage != null ?  Image.file(File(productController.productImage!.path),
                              width: 150, height: 120, fit: BoxFit.cover,
                            ) :widget.product!=null? FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              image: '${Get.find<SplashController>().baseUrls!.productImageUrl}/${widget.product!.image ?? ''}',
                              height: 120, width: 150, fit: BoxFit.cover,
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                                  height: 120, width: 150, fit: BoxFit.cover),
                            ):Image.asset(Images.placeholder,height: 120,
                              width: 150, fit: BoxFit.cover,),
                          ),
                          Positioned(
                            bottom: 0, right: 0, top: 0, left: 0,
                            child: InkWell(
                              onTap: () => productController.pickImage(false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(25),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2, color: Colors.white),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ]));
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    );
  }
}
