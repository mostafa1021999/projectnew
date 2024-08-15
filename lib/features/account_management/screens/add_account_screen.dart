import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/account_controller.dart';
import 'package:six_pos/common/models/account_model.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';

class AddAccountScreen extends StatefulWidget {
  final Accounts? account;
  const AddAccountScreen({Key? key, this.account}) : super(key: key);

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {

  TextEditingController accountTitle = TextEditingController();
  TextEditingController accountDescription = TextEditingController();
  TextEditingController accountBalance = TextEditingController();
  TextEditingController accountNumber = TextEditingController();

  FocusNode accountTitleNode = FocusNode();
  FocusNode accountDescriptionNode = FocusNode();
  FocusNode accountBalanceNode = FocusNode();
  FocusNode accountNumberNode = FocusNode();


  late bool update;
  @override
  void initState() {
    super.initState();
    update = widget.account != null;

    if(update){
      accountTitle.text = widget.account!.account!;
      accountDescription.text = widget.account!.description!;
      accountBalance.text = widget.account!.balance.toString();
      accountNumber.text = widget.account!.accountNumber!;
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(isBackButtonExist: true),
      endDrawer: const CustomDrawerWidget(),
      body: GetBuilder<AccountController>(
        builder: (accountController) {
          return Column(children: [
            CustomHeaderWidget(title: 'add_account'.tr, headerImage: Images.account),

            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(
                      hintText: 'ex_new_year_discount'.tr,
                        focusNode: accountTitleNode,
                        nextFocus: accountDescriptionNode,
                        inputAction: TextInputAction.next,
                        controller: accountTitle),
                    title: 'account_title'.tr,
                    requiredField: true,
                  ),

                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(
                      hintText: 'description'.tr,
                      controller: accountDescription,
                      inputAction: TextInputAction.next,
                      focusNode: accountDescriptionNode,
                      nextFocus: accountBalanceNode,),
                    title: 'description'.tr,
                    requiredField: true,
                  ),



                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(
                        hintText: 'init_balance_hint'.tr,
                        controller: accountBalance,
                        inputAction: TextInputAction.next,
                        isEnabled: update? false : true,
                        inputType: TextInputType.number),
                    title: 'initial_balance'.tr,
                    requiredField: true,
                  ),

                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(
                      hintText: 'acc_hint'.tr,
                      controller: accountNumber,
                      inputAction: TextInputAction.done,
                    ),
                    title: 'account_number'.tr,
                    requiredField: true,
                  ),
                ]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonWidget(
                isLoading: accountController.isLoading,
                buttonText: update ? 'update'.tr : 'save'.tr,
                onPressed: (){

                String title = accountTitle.text.trim();
                String description = accountDescription.text.trim();
                String balance = accountBalance.text.trim();
                String accountNum = accountNumber.text.trim();


                if(title.isEmpty){
                  showCustomSnackBarHelper('account_title_required'.tr);
                }else if(description.isEmpty){
                  showCustomSnackBarHelper('account_description_required'.tr);
                }else if(balance.isEmpty){
                  showCustomSnackBarHelper('account_balance_required'.tr);
                }else if(double.parse(balance) < 0){
                  showCustomSnackBarHelper('balance_should_be_greater_than_0'.tr);
                }
                else if(accountNum.isEmpty){
                  showCustomSnackBarHelper('account_number_required'.tr);
                }else{
                  Accounts account =Accounts(
                    id: update? widget.account!.id : null,
                    account: title,
                    description:  description,
                    balance: double.parse(balance),
                    accountNumber: accountNum,

                  );
                  accountController.addAccount(account,update);


                }


              },
              ),
            ),
          ]);
        }
      ),
    );
  }
}
