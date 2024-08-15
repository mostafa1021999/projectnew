import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/features/user/domain/models/supplier_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';


class ProductPriceInfoWidget extends StatefulWidget {
  const ProductPriceInfoWidget({Key? key}) : super(key: key);

  @override
  State<ProductPriceInfoWidget> createState() => _ProductPriceInfoWidgetState();
}

class _ProductPriceInfoWidgetState extends State<ProductPriceInfoWidget> {

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'selling_price_hint'.tr,
                      controller: productController.productSellingPriceController,
                        inputType: TextInputType.number,
                      ),
                      title: 'selling_price'.tr,
                      requiredField: true,
                    ),
                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'purchase_price_hint'.tr,
                      controller: productController.productPurchasePriceController,
                        inputType: TextInputType.number,
                      ),
                      title: 'purchase_price'.tr,
                      requiredField: true,
                    ),


                    Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('discount_type'.tr,
                          style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

                          ),
                          child: DropdownButton<String>(
                            value: productController.discountTypeIndex == 0 ? 'percent' : 'amount',
                            items: <String>['percent', 'amount'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.tr),
                              );
                            }).toList(),
                            onChanged: (value) {
                              productController.setSelectedDiscountType(value);
                              productController.setDiscountTypeIndex(value == 'percent' ? 0 : 1, true);

                            },
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'discount_hint'.tr,
                      controller: productController.productDiscountController,
                        inputType: TextInputType.number,
                      ),
                      title: 'discount_percentage'.tr,
                      requiredField: true,
                    ),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'tax_hint'.tr,
                      controller: productController.productTaxController,
                        inputType: TextInputType.number,
                      ),
                      title: '${'tax'.tr}  (%)',
                      requiredField: true,
                    ),


                    GetBuilder<SupplierController>(
                        builder: (supplierController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_supplier'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                                child: DropdownButton<int>(
                                  hint: Text('select'.tr),
                                  value: supplierController.selectedSupplierId,
                                  items: supplierController.supplierModel?.supplierList?.map((Suppliers? value) {
                                    return DropdownMenuItem<int>(
                                        value: value?.id,
                                        child: Text(value?.name ?? ''));
                                  }).toList(),
                                  onChanged: (int? value) {
                                    supplierController.setSupplierIndex(value, true);
                                  },
                                  isExpanded: true, underline: const SizedBox(),),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                            ],),
                          );
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
