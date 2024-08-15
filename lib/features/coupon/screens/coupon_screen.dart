
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_category_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/coupon/screens/add_coupon_screen.dart';
import 'package:six_pos/features/coupon/screens/coupon_list_screen.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .12;
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),
      appBar: const CustomAppBarWidget(),
      body: Column(children: [

        InkWell(
          onTap: () => Get.to(() => const CouponListScreen()),
          child: CustomCategoryButtonWidget(
            padding: width,
            buttonText: 'coupon_list'.tr,
            icon: Images.couponListIcon,
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeDefault),

        InkWell(
          onTap: () => Get.to(() => const AddCouponScreen()),
          child: CustomCategoryButtonWidget(
            padding: width,
            buttonText: 'add_new_coupon'.tr,
            icon: Images.addCategoryIcon,
          ),
        ),

    ],),);
  }
}
