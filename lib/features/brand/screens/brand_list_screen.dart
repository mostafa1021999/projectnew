import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/features/brand/screens/add_new_brand_screen.dart';
import 'package:six_pos/features/brand/widgets/brand_list_widget.dart';
class BrandListScreen extends StatefulWidget {
  const BrandListScreen({Key? key}) : super(key: key);

  @override
  State<BrandListScreen> createState() => _BrandListScreenState();
}

class _BrandListScreenState extends State<BrandListScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<BrandController>().getBrandList(1, isUpdate: false);
  }

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
                    CustomHeaderWidget(title: 'brand_list'.tr, headerImage: Images.brand),
                    const SizedBox(height: Dimensions.paddingSizeDefault    ),
                    BrandListWidget(scrollController: _scrollController,),
                    const SizedBox(height: 100),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Get.to(const AddNewBrandScreen());
        },child: Image.asset(Images.addCategoryIcon),),
    );
  }
}
