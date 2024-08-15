import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_category_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/category/screens/category_list_screen.dart';
import 'package:six_pos/features/category/screens/sub_category_list_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().getCategoryList(1, isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .15 ;
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: Column(children: [


        CustomCategoryButtonWidget(buttonText: 'categories'.tr,icon: Images.categories,
            isSelected: false,isDrawer: false, padding: width,onTap: ()=> Get.to(()=> const CategoryListScreen()),
        ),

        CustomCategoryButtonWidget(buttonText: 'sub_categories'.tr,
          icon: Images.categories,isSelected: false,
          padding: width,isDrawer: false, onTap: () => Get.to(()=> const SubCategoryListScreen())),

      ],),
    );
  }
}
