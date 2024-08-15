import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_category_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/brand/screens/brand_list_screen.dart';
import 'package:six_pos/features/category/screens/category_screen.dart';
import 'package:six_pos/features/coupon/screens/coupon_screen.dart';
import 'package:six_pos/features/product_setup/screens/product_setup_screen.dart';
import 'package:six_pos/features/unit/screens/unit_list_screen.dart';


class ProductSetupMenuScreen extends StatelessWidget {
  final bool isFromDrawer;
  const ProductSetupMenuScreen({Key? key, this.isFromDrawer = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();
    double width = MediaQuery.of(context).size.width * .12;

    return Scaffold(
      appBar: isFromDrawer? const CustomAppBarWidget(): null,
      endDrawer: const CustomDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(children: [

          if(profileController.modulePermission?.category ?? false) CustomCategoryButtonWidget(
            buttonText: 'categories'.tr,icon: Images.categories,
            isSelected: false,
            isDrawer: false,
            padding: width,
            onTap: ()=> Get.to(const CategoryScreen()),
          ),

          if(profileController.modulePermission?.brand ?? false) CustomCategoryButtonWidget(
            buttonText: 'brands'.tr,
            icon: Images.brand,isSelected: false,
            onTap: ()=> Get.to(const BrandListScreen()),
            padding: width,isDrawer: false,
          ),

          if(profileController.modulePermission?.unit ?? false) CustomCategoryButtonWidget(
            buttonText: 'product_units'.tr,
            icon: Images.productUnit,isSelected: false,
            onTap: ()=> Get.to(const UnitListViewScreen()),
            padding: width,isDrawer: false,
          ),

          if(profileController.modulePermission?.product ?? false) CustomCategoryButtonWidget(buttonText: 'product_setup'.tr,
            icon: Images.productSetup,isSelected: false,
            onTap: ()=>  Get.to(const ProductSetupScreen()),
            padding: width,isDrawer: false,),

          if(profileController.modulePermission?.coupon ?? false) CustomCategoryButtonWidget(buttonText: 'coupons'.tr,
            icon: Images.coupon,isSelected: false,
            onTap: ()=> Get.to(const CouponScreen()),
            padding: width,isDrawer: false,)

        ],),
      ),
    );
  }
}
