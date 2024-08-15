import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_category_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/account_management/screens/account_list_screen.dart';
import 'package:six_pos/features/account_management/screens/add_account_screen.dart';
import 'package:six_pos/features/account_management/screens/add_new_expense_screen.dart';
import 'package:six_pos/features/account_management/screens/add_new_transfer_screen.dart';
import 'package:six_pos/features/account_management/screens/transaction_list_screen.dart';

import '../../../util/app_constants.dart';

class AccountManagementScreen extends StatelessWidget {
  const AccountManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.12;
    return Scaffold(
      appBar: const CustomAppBarWidget(isBackButtonExist: true),
      endDrawer: const CustomDrawerWidget(),
      body: ListView(children: [

        CustomCategoryButtonWidget(
          buttonText: 'account_list'.tr,
          icon: Images.account,
          isSelected: false,
          isDrawer: false,
          padding: width,
          onTap: ()=> Get.to(()=> const AccountListScreen(fromAccount: true,)),
        ),

        CustomCategoryButtonWidget(
          buttonText: 'add_account'.tr,
          icon: Images.account,
          isSelected: false,
          padding: width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> const AddAccountScreen()),
        ),

        CustomCategoryButtonWidget(
          buttonText: Languagevalue=='ar'?'قائمه المصاريف':'expense_list'.tr,
          icon: Images.expense,
          isSelected: false,
          isDrawer: false,
          padding: width,
          onTap: ()=> Get.to(()=> const AccountListScreen()),
        ),

        CustomCategoryButtonWidget(
          buttonText: Languagevalue=='ar'?'اضافة مصاريف':'add_new_expanse'.tr,
          icon: Images.expense,
          isSelected: false,
          padding: width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> const AddNewExpenseScreen()),
        ),

        CustomCategoryButtonWidget(
          buttonText: 'income_list'.tr,
          icon: Images.income,
          isSelected: false,
          isDrawer: false,
          padding: width,
          onTap: ()=> Get.to(()=> const AccountListScreen(isIncome: true)),
        ),

        CustomCategoryButtonWidget(
          buttonText: 'add_new_income'.tr,
          icon: Images.income,
          isSelected: false,
          padding: width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> const AddNewExpenseScreen(fromIncome: true,)),
        ),

        CustomCategoryButtonWidget(
          buttonText: 'add_new_transfer'.tr,
          icon: Images.brand,
          isSelected: false,
          padding: width,
          isDrawer: false,
          onTap: ()=> Get.to(()=> const AddNewTransferScreen()),
        ),

        CustomCategoryButtonWidget(
          buttonText: 'transaction_list'.tr,
          icon: Images.transaction,
          isSelected: false,
          isDrawer: false,
          padding: width,
          onTap: ()=> Get.to(()=> const TransactionListScreen()),
        ),

      ]),

    );
  }
}
