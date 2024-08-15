import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/coupon/controllers/coupon_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/features/coupon/screens/add_coupon_screen.dart';
import 'package:six_pos/features/coupon/widgets/coupon_list_widget.dart';




class CouponListScreen extends StatefulWidget {
  const CouponListScreen({Key? key}) : super(key: key);

  @override
  State<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  @override
  initState(){
    super.initState();
    Get.find<CouponController>().getCouponList(1, isUpdate: false);
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
                    CustomHeaderWidget(title: 'coupon_list'.tr, headerImage: Images.categories),
                    const SizedBox(height: Dimensions.paddingSizeDefault    ),
                    CouponListWidget(scrollController: _scrollController),
                  ],
                ),
              )
            ],
          ),
        ),
      ),



      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: ColorResources.whiteColor,
        child: Image.asset(Images.addNewCategory),
        onPressed: () => Get.to(() => const AddCouponScreen()),
      ),
    );
  }
}
