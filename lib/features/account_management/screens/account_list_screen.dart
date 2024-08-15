import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/account_controller.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/features/account_management/controllers/expense_controller.dart';
import 'package:six_pos/features/account_management/controllers/income_controller.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_date_picker_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/secondary_header_widget.dart';
import 'package:six_pos/features/account_management/widgets/account_list_widget.dart';
import 'package:six_pos/common/widgets/custom_search_field_widget.dart';
import 'package:six_pos/features/account_management/widgets/expense_list_widget.dart';
import 'package:six_pos/features/account_management/widgets/income_list_widget.dart';

class AccountListScreen extends StatefulWidget {
  final bool fromAccount;
  final bool isIncome;
  const AccountListScreen({Key? key, this.fromAccount = false, this.isIncome = false}) : super(key: key);

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    if(widget.isIncome){
      Get.find<IncomeController>().getIncomeList(1, reload: true);
    }else if(widget.fromAccount){
      Get.find<AccountController>().getAccountList(1, isUpdate: false);
    }else{
      Get.find<ExpenseController>().clearDatePicker();
      Get.find<ExpenseController>().getExpenseList(1, isUpdate: false);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(isBackButtonExist: true),
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
                child:  Column(children: [
                  CustomHeaderWidget(
                    title: widget.isIncome ? 'income_list'.tr : widget.fromAccount
                        ? 'account_list'.tr : 'expense_List'.tr ,
                    headerImage: widget.isIncome ? Images.income : widget.fromAccount ? Images.account : Images.expense,

                  ),

                  widget.fromAccount?
                  GetBuilder<AccountController>(
                      builder: (accountController) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeSmall),
                          child: CustomSearchFieldWidget(
                            controller: searchController,
                            hint: 'search_account'.tr,
                            prefix: Icons.search,
                            iconPressed: () => (){},
                            onSubmit: (text) => (){},
                            onChanged: (value){
                              accountController.onSearchAccount(value);
                            },
                            isFilter: false,
                          ),
                        );
                      }
                  ):const SizedBox(),

                  widget.fromAccount ? const SizedBox() :
                  GetBuilder<ExpenseController>(
                      builder: (expenseController) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
                            Expanded(
                              child: CustomDatePickerWidget(
                                title: 'from'.tr,
                                text: expenseController.startDate != null ?
                                expenseController.dateFormat.format(expenseController.startDate!).toString() : 'select_date'.tr,
                                image: Images.calender,
                                requiredField: true,
                                selectDate: () => expenseController.selectDate("start"),
                              ),
                            ),

                            Expanded(
                              child: CustomDatePickerWidget(
                                title: 'to'.tr,
                                text: expenseController.endDate != null ?
                                expenseController.dateFormat.format(expenseController.endDate!).toString() : 'select_date'.tr,
                                image: Images.calender,
                                requiredField: true,
                                selectDate: () {
                                  if(expenseController.startDate != null) {
                                    expenseController.selectDate("end", disableBeforeDate: expenseController.startDate);
                                  }else{
                                    showCustomSnackBarHelper('select_start_date'.tr);
                                  }
                                },
                              ),
                            ),


                            CustomButtonWidget(
                              width: 60,
                              onPressed: (){
                                if(widget.isIncome){
                                  Get.find<IncomeController>().getIncomeFilter(
                                    expenseController.dateFormat.format(expenseController.startDate!).toString(),
                                    expenseController.dateFormat.format(expenseController.endDate!).toString(),
                                  );
                                }else{
                                  if(expenseController.startDate == null || expenseController.endDate == null) {
                                    showCustomSnackBarHelper('select_date_range_first'.tr);
                                  }else {
                                    expenseController.getExpenseFilter(
                                      expenseController.dateFormat.format(expenseController.startDate!),
                                      expenseController.dateFormat.format(expenseController.endDate!),
                                    );
                                  }

                                }
                              },
                              buttonText: 'filter'.tr,
                            ),
                          ],),
                        );
                      }
                  ),


                  SecondaryHeaderWidget(isSerial: true, key: UniqueKey(), showOwnTitle: true,title: 'account_info'.tr,),


                  widget.isIncome? IncomeListWidget(scrollController: _scrollController) :
                  widget.fromAccount?  AccountListWidget(scrollController: _scrollController) :
                  ExpenseListWidget(isHome: false,scrollController: _scrollController)


                ]),
              )
            ],
          ),
        ),
      ),


    );
  }
}
