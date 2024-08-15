
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';

import 'category_card_widget.dart';
class CategoryListWidget extends StatelessWidget {
  final ScrollController scrollController;
  const CategoryListWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return GetBuilder<CategoryController>(
      builder: (categoryController) {

        return categoryController.categoryModel == null ? const CustomLoaderWidget(
        ) : (categoryController.categoryModel?.categoriesList?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          onPaginate: (int? offset) async => await categoryController.getCategoryList(offset ?? 1),
          totalSize: categoryController.categoryModel?.totalSize,
          offset: categoryController.categoryModel?.offset,
          itemView: ListView.builder(
            shrinkWrap: true,
            itemCount: categoryController.categoryModel?.categoriesList?.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return CategoryCardWidget(
                category: categoryController.categoryModel?.categoriesList?[index],
                index: index,
              );
            },
          ),
        ) : const NoDataWidget();

      },
    );
  }
}
