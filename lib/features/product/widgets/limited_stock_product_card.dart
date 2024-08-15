import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/product/domain/models/limite_stock_product_model.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/features/product/widgets/product_update_dialog_widget.dart';
import 'package:six_pos/features/user/widgets/custom_divider_widget.dart';
class LimitedStockProductCardViewWidget extends StatelessWidget {
  final StockLimitedProducts? product;
  final bool isHome;
  final int? index;
  const LimitedStockProductCardViewWidget({Key? key, this.product, this.isHome = false, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isHome? Container(height: 40,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        children: [
          Row(
            children: [
              Text('${index! + 1}.', style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor)),
              const SizedBox(width: Dimensions.paddingSizeLarge),
              Expanded(child: Text('${product!.name}', maxLines: 1,overflow: TextOverflow.ellipsis,
                  style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor))),
              const Spacer(),
              Text('${product!.quantity}', style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor)),

            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeSmall),
          CustomDividerWidget(color: Theme.of(context).hintColor,height: .5)
        ],
      ),
    )
        :Column(children: [
      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall,
          horizontal: Dimensions.paddingSizeSmall,
        ),
        child: Column( crossAxisAlignment:CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeBorder),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                    color: Theme.of(context).primaryColor.withOpacity(.12),
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                      child: CustomImageWidget(
                        image: '${Get.find<SplashController>().configModel!.baseUrls!.productImageUrl}/${product!.image}',
                        width: 60, height: 60, fit: BoxFit.cover, placeholder: Images.placeholder,
                      ))),
              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Expanded(
                child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
                  children: [
                    Text(product!.name!, style: fontSizeRegular.copyWith(),maxLines: 2,overflow: TextOverflow.ellipsis),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('${'code'.tr} : ${product!.productCode}', style: fontSizeRegular.copyWith(
                              color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
                        ),
                        GetBuilder<ProductController>(
                          builder: (productController) {
                            return InkWell(
                              onTap: (){
                                productController.productQuantityController.clear();

                                showAnimatedDialogHelper(context,
                                    ProductUpdateDialogWidget(
                                      onYesPressed: (){
                                        int inputQuantity = int.tryParse(productController.productQuantityController.text.trim()) ?? 0;

                                        if(product?.quantity != null) {
                                          productController.updateProductQuantity(product?.id, inputQuantity);
                                          Get.back();
                                        }
                                      },
                                    ),
                                    dismissible: false,
                                    isFlip: false);
                              },
                              child: Row(children: [
                                const Icon(Icons.add_circle),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                  child: Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge,vertical: Dimensions.paddingSizeExtraSmall),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),

                                    ),
                                    child: Text('${product?.quantity}'),),
                                ),

                              ]),
                            );
                          }
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),
          Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            child: CustomDividerWidget(color: Theme.of(context).hintColor),
          ),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Padding( padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    child: Text('${'purchase_price'.tr} : ${PriceConverterHelper.priceWithSymbol(product!.sellingPrice!)}', style: fontSizeRegular.copyWith(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize: Dimensions.fontSizeLarge,
                    )),
                  ),
                  Text('supplier_information'.tr, style: fontSizeRegular.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: Dimensions.fontSizeLarge,
                  )),

                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  product!.supplier != null?
                  Padding( padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                    child: Text(product!.supplier!.name??'', style: fontSizeRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeLarge,
                    )),
                  ):const SizedBox(),

                  product!.supplier != null?
                  Padding( padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                    child: Text(product!.supplier!.mobile??'', style: fontSizeRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      fontSize: Dimensions.fontSizeLarge,
                    )),
                  ):const SizedBox(),
                ],),
              )
            ],),
        ]),
      ),
      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
    ],);
  }
}
