import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_category_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/user/screens/user_list_sceeen.dart';
import 'package:six_pos/features/user/screens/add_new_user_screen.dart';

class OptionListScreen extends StatelessWidget {
  const OptionListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find<ProfileController>();

    final double width = MediaQuery.of(context).size.width * 0.12;
    return Scaffold(
      appBar: const CustomAppBarWidget(isBackButtonExist: true),
      endDrawer: const CustomDrawerWidget(),
      body: ListView(children: [

        if(profileController.modulePermission?.supplier ?? false) CustomCategoryButtonWidget(
          buttonText: 'supplier_list'.tr,
          icon: Images.peopleIcon,
          isSelected: false,
          isDrawer: false,
          padding: width,
          onTap: ()=> Get.to(()=> const UserListScreen()),
        ),

        if(profileController.modulePermission?.supplier ?? false) CustomCategoryButtonWidget(
          buttonText: 'add_new_supplier'.tr,
          icon: Images.addCategoryIcon,
          isSelected: false,
          padding: width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> const AddNewUserScreen()),
        ),

        if(profileController.modulePermission?.customer ?? false) CustomCategoryButtonWidget(
          buttonText: 'customer_list'.tr,
          icon: Images.peopleIcon,
          isSelected: false,
          isDrawer: false,
          padding: width,
          onTap: ()=> Get.to(()=> const UserListScreen(isCustomer: true)),
        ),

        if(profileController.modulePermission?.customer ?? false) CustomCategoryButtonWidget(
          buttonText: 'add_new_customer'.tr,
          icon: Images.addCategoryIcon,
          isSelected: false,
          padding: width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> const AddNewUserScreen( isCustomer: true,)),
        ),


      ]),

    );
  }
}
