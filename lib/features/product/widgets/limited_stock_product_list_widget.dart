import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/product/widgets/limited_stock_product_card.dart';



class LimitedStockProductListWidget extends StatelessWidget {
  final bool isHome;
  final ScrollController scrollController;
  const LimitedStockProductListWidget({Key? key, required this.scrollController, this.isHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {

        return productController.limitedStockProductModel?.stockLimitedProducts == null ? const CustomLoaderWidget(
        ) : (productController.limitedStockProductModel?.stockLimitedProducts?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          totalSize: productController.limitedStockProductModel?.totalSize,
          onPaginate: (int? offset) async => await productController.getLimitedStockProductList(offset ?? 1),
          offset: productController.limitedStockProductModel?.offset,
          limit: productController.limitedStockProductModel?.limit ?? 10,
          itemView: ListView.builder(
            shrinkWrap: true,
            itemCount: isHome &&  ((productController.limitedStockProductModel?.stockLimitedProducts?.length ?? 0) > 2)
                ? 3: productController.limitedStockProductModel?.stockLimitedProducts?.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index)=> LimitedStockProductCardViewWidget(
              product: productController.limitedStockProductModel?.stockLimitedProducts?[index],
              index: index, isHome: isHome,
            ),
          ),
        ) : const NoDataWidget();
      },
    );
  }
}
