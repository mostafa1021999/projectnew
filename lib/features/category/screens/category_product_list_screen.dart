import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_search_field_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/product/widgets/category_item_widget.dart';
import 'package:six_pos/features/product/widgets/item_card_widget.dart';
import 'package:six_pos/features/category/widgets/product_search_dialog_widget.dart';

class CategoryProductListScreen extends StatefulWidget {
  const CategoryProductListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryProductListScreen> createState() => _CategoryProductListScreenState();
}

class _CategoryProductListScreenState extends State<CategoryProductListScreen> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final CategoryController categoryController = Get.find<CategoryController>();

    categoryController.getSearchProductList('');
    categoryController.changeSelectedIndex(0);
    if((categoryController.categoryModel?.categoriesList?.isNotEmpty ?? false)){
      categoryController.getCategoryWiseProductList(categoryController.categoryModel?.categoriesList?[0].id, isUpdate: false);
    }

  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.find<CategoryController>().getSearchProductList('', isReset: true);
        searchController.clear();
      },
      child: Scaffold(
        body: Column(
          children: [
            CustomHeaderWidget(title: 'products'.tr, headerImage: Images.product),

            GetBuilder<CategoryController>(
              builder: (searchProductController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault,
                  vertical: Dimensions.paddingSizeSmall),
                  child: CustomSearchFieldWidget(
                    controller: searchController,
                    hint: 'search_product_by_name_or_barcode'.tr,
                    prefix: Icons.search,
                    iconPressed: () => (){},
                    onSubmit: (text) => (){},
                    onChanged: (value){
                      searchProductController.getSearchProductList(value);
                    },
                    isFilter: false,
                  ),
                );
              }
            ),

            Expanded(child: Stack(children: [
              GetBuilder<CategoryController>(builder: (categoryController) {
                return (categoryController.categoryModel?.categoriesList?.isNotEmpty ?? false) ?
                Row(children: [
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(top: 3),
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: ColorResources.getCategoryWithProductColor(),
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(Dimensions.paddingSizeLarge))
                    ),
                    child: PaginatedListWidget(
                      scrollController: scrollController,
                      onPaginate: (int? offset) async => await categoryController.getCategoryList(offset ?? 1),
                      offset: categoryController.categoryModel?.offset,
                      totalSize: categoryController.categoryModel?.totalSize,
                      itemView: Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: categoryController.categoryModel?.categoriesList?.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            Categories? category = categoryController.categoryModel?.categoriesList?[index];
                            return category?.status == 1 ?   InkWell(
                              onTap: () {
                                Get.find<CategoryController>().changeSelectedIndex(index);
                                Get.find<CategoryController>().getCategoryWiseProductList(category?.id);
                              },
                              child: CategoryItemWidget(
                                title: category?.name,
                                icon: category?.image,
                                isSelected: categoryController.categorySelectedIndex == index,
                              ),
                            ) : const SizedBox();

                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeMediumBorder),

                  Expanded(child: categoryController.categoriesProductList == null ? const _ProductShimmer() : (categoryController.categoriesProductList?.isNotEmpty ?? false) ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('all_product_from'.tr, style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                              child: Text(' ${categoryController.categoryModel?.categoriesList?[categoryController.categorySelectedIndex!].name}',
                                textAlign: TextAlign.start,
                                maxLines:3,
                                style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                            ),
                          ],
                        ),
                      ),

                      Expanded(child: Padding(
                        padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeSmall),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childAspectRatio: 0.73,
                          ),
                          padding: const EdgeInsets.all(0),
                          itemCount: categoryController.categoriesProductList!.length,
                          itemBuilder: (context, index) {

                            return ItemCardWidget(categoriesProduct: categoryController.categoriesProductList![index], index: index);
                          },
                        ),
                      )),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                    ]) : const NoDataWidget()),

                ]) : const NoDataWidget();
              }),

              const ProductSearchDialogWidget(),
            ])),
          ],
        ),
      ),
    );
  }

}

class _ProductShimmer extends StatelessWidget {
  const _ProductShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: 12,
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).highlightColor,
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[100]!,
            enabled: true,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // Product Image
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorResources.getIconBg(),
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                  ),
                ),
              ),

              // Product Details
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 20, color: Colors.white),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(height: 20, width: 50, color: Colors.white),
                          ]),
                        ),
                        Container(height: 10, width: 50, color: Colors.white),
                      ]),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}




