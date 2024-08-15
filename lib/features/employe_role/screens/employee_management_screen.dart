import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_category_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/employe_role/screens/employee_list_screen.dart';
import 'package:six_pos/features/employe_role/screens/role_list_screen.dart';
import 'package:six_pos/util/images.dart';

class EmployeeManagementScreen extends StatelessWidget {
  const EmployeeManagementScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * .12;

    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(children: [

          CustomCategoryButtonWidget(
            buttonText: 'role_list'.tr,
            icon: Images.employeeRole,
            isSelected: false,
            isDrawer: false,
            padding: width,
            onTap: ()=> Get.to(()=> const EmployeeRoleListScreen()),
          ),

          CustomCategoryButtonWidget(
            buttonText: 'employee_list'.tr,
            icon: Images.employeeList,
            isSelected: false,
            onTap: ()=> Get.to(const EmployeeListScreen()),
            padding: width,
            isDrawer: false,
          ),


        ],),
      ),
    );
  }
}
