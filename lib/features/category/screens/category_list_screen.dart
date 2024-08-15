import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/features/category/screens/add_new_category_screen.dart';
import 'package:six_pos/features/category/widgets/category_list_widget.dart';
class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({Key? key}) : super(key: key);

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
        body: SafeArea(
          child: RefreshIndicator(
            color: Theme.of(context).cardColor,
            backgroundColor: Theme.of(context).primaryColor,
            onRefresh: () async {
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CustomHeaderWidget(title: 'category_list'.tr, headerImage: Images.categories),
                      const SizedBox(height: Dimensions.paddingSizeDefault    ),
                      CategoryListWidget(scrollController: _scrollController,),
                      const SizedBox(height: Dimensions.paddingSizeExtraExtraLarge)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

      floatingActionButton: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
        Get.to(const AddNewCategoryScreen());
      },child: Image.asset(Images.addCategoryIcon),),
    );
  }
}
