import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/product_setup/screens/add_product_screen.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_search_field_widget.dart';
import 'package:six_pos/common/widgets/secondary_header_widget.dart';
import 'package:six_pos/features/product/widgets/product_list_widget.dart';

class ProductScreen extends StatefulWidget {
  final int? supplierId;
  const ProductScreen({Key? key, this.supplierId}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();

    final ProductController productController = Get.find<ProductController>();
    if(widget.supplierId != null){
      productController.getSupplierProductList(1, widget.supplierId);
    }else{
      productController.getProductList(1, isUpdate: false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),
      appBar:  const CustomAppBarWidget(isBackButtonExist: true),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Image.asset(Images.addCategoryIcon),
        onPressed: () {
          Get.to(()=> AddProductScreen(supplierId: widget.supplierId));
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            searchController.clear();

            if(widget.supplierId != null) {
              Get.find<ProductController>().getSupplierProductList(1, widget.supplierId);

            }else {
              Get.find<ProductController>().getProductList(1);
            }

          },

          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(children: [
                  CustomHeaderWidget(title:  'product_list'.tr , headerImage: Images.peopleIcon),

                  if(widget.supplierId == null) GetBuilder<ProductController>(
                      builder: (productController) {
                        return Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                          child: CustomSearchFieldWidget(
                            controller: searchController,
                            hint: 'search_product_by_name_or_barcode'.tr,
                            prefix: Icons.search,
                            iconPressed: () => (){},
                            onSubmit: (text) => (){},
                            onChanged: (String value){
                              setState(() {
                                if((value.isNotEmpty)){
                                  productController.getSearchProductList(value, 1);
                                }else{
                                  if(widget.supplierId == null) {
                                    productController.getProductList(1);

                                  }else{
                                    productController.getSupplierProductList(1, widget.supplierId);
                                  }
                                }
                              });
                            },
                            isFilter: false,
                          ),
                        );
                      }),

                  SecondaryHeaderWidget(key: UniqueKey()),

                  ProductListWidget(
                    scrollController: _scrollController,
                    searchName: searchController.text,
                    supplierId: widget.supplierId,
                  ),

                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 70 || oldDelegate.minExtent != 70 || child != oldDelegate.child;
  }
}