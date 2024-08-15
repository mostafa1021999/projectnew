import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/category/widgets/sub_category_card_widget.dart';
class SubCategoryListWidget extends StatelessWidget {
  final ScrollController scrollController;
  const SubCategoryListWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CategoryController>(builder: (categoryController) {

        return categoryController.subCategoryModel == null ? const CustomLoaderWidget(
        ) : (categoryController.subCategoryModel?.subCategoriesList?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          onPaginate: (int? offset) => categoryController.getSubCategoryList(offset ?? 1, categoryController.selectedCategoryId),
          totalSize: categoryController.subCategoryModel?.totalSize,
          offset: categoryController.subCategoryModel?.offset,
          itemView: ListView.builder(
            shrinkWrap: true,
            itemCount: categoryController.subCategoryModel?.subCategoriesList?.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return SubCategoryCardWidget(subCategory: categoryController.subCategoryModel?.subCategoriesList?[index]);
            },
          ),
        ) : const NoDataWidget();
      },
    );
  }
  }

