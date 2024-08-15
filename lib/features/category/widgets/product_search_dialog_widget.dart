import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/controllers/theme_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/features/product/widgets/searched_product_item_widget.dart';
class ProductSearchDialogWidget extends StatelessWidget {
  const ProductSearchDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(builder: (searchedProductController){
      return searchedProductController.searchedProductList != null && searchedProductController.searchedProductList!.isNotEmpty?
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
        child: Container(height: 400,
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              boxShadow: [BoxShadow(color: Colors.grey[Get.find<ThemeController>().darkTheme ? 800 : 400]!,
                  spreadRadius: .5, blurRadius: 12, offset: const Offset(3,5))]

          ),
          child: ListView.builder(
              itemCount: searchedProductController.searchedProductList!.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return SearchedProductItemWidget(product: searchedProductController.searchedProductList![index]);

              }),
        ),
      ):const SizedBox.shrink();
    });
  }
}
