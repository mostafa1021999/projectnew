import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/common/models/cart_model.dart';
import 'package:six_pos/features/product/domain/models/categories_product_model.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
class ItemCardWidget extends StatelessWidget {
  final int? index;
  final CategoriesProduct? categoriesProduct;
  const ItemCardWidget({Key? key, this.categoriesProduct, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (cartController) {
        return InkWell(
          onTap: (){
            if(categoriesProduct!.quantity!<1){
              showCustomSnackBarHelper('stock_out'.tr);
            }else{
              CartModel cartModel = CartModel(categoriesProduct!.sellingPrice, categoriesProduct!.discount, 1, categoriesProduct!.tax, categoriesProduct);
              cartController.addToCart(cartModel);
            }

          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeBorder),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.1), width: 1),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                      child: CustomImageWidget(
                        image: '${Get.find<SplashController>().configModel?.baseUrls?.productImageUrl}/${categoriesProduct?.image}',
                        placeholder: Images.placeholder,
                        fit: BoxFit.cover,
                        width: 200,
                        height: 100,
                      ),
                    ),
                  ),
                ),

               Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                 categoriesProduct!.discount!>0 ?
                 Text(PriceConverterHelper.priceWithSymbol(categoriesProduct!.sellingPrice!,),
                   style: fontSizeLight.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor,decoration: TextDecoration.lineThrough),):const SizedBox(),
                 const SizedBox(height: Dimensions.paddingSizeBorder),


                 Text(
                   PriceConverterHelper.convertPrice(context, categoriesProduct!.sellingPrice, discount: categoriesProduct!.discount ,discountType : categoriesProduct!.discountType),
                   style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),
                 ),
               ]),

                Text(
                  categoriesProduct?.title ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

              ]),),
        );
      }
    );
  }
}
