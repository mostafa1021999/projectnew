import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:six_pos/features/account_management/controllers/expense_controller.dart';
import 'package:six_pos/features/account_management/controllers/income_controller.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/features/account_management/domain/models/expense_model.dart';
import 'package:six_pos/features/account_management/domain/models/income_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';


class AddNewExpenseScreen extends StatefulWidget {
  final bool fromIncome;
  final Expenses? expense;
  const AddNewExpenseScreen({Key? key, this.expense, this.fromIncome = false}) : super(key: key);

  @override
  State<AddNewExpenseScreen> createState() => _AddNewExpenseScreenState();
}

class _AddNewExpenseScreenState extends State<AddNewExpenseScreen> {


  TextEditingController expenseDescriptionController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();
  TextEditingController expenseDateController = TextEditingController();


  FocusNode accountDescriptionNode = FocusNode();
  FocusNode accountBalanceNode = FocusNode();
  FocusNode accountNumberNode = FocusNode();

  late bool update;
  @override
  void initState() {
    super.initState();
    update = widget.expense != null;
    if(update){
      expenseDescriptionController.text = widget.expense!.description!;
      expenseAmountController.text = widget.expense!.amount.toString();
      expenseDateController.text = widget.expense!.date!;
    }
  }



  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2022, 1),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
          expenseDateController.text = formattedDate;

        });
      }
    }
    return Scaffold(
      appBar: const CustomAppBarWidget(isBackButtonExist: true),
      endDrawer: const CustomDrawerWidget(),
      body: GetBuilder<ExpenseController>(
          builder: (expenseController) {
            return Column(children: [
              CustomHeaderWidget(
                title: widget.fromIncome ? 'add_income'.tr : 'add_expense'.tr,
                headerImage: widget.fromIncome ? Images.income  : Images.expense,
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    GetBuilder<TransactionController>(
                        builder: (accountController) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('select_account'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                                decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                    border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                                child: DropdownButton<int>(
                                  hint: Text('select'.tr),
                                  value: accountController.fromAccountIndex,
                                  items: accountController.fromAccountIds?.map((int? value) {
                                    return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(
                                        accountController.accountList![(accountController.fromAccountIds!.indexOf(value))].account!));}).toList(),
                                  onChanged: (int? value) {
                                    accountController.setAccountIndex(value,'from', true);
                                  },
                                  isExpanded: true, underline: const SizedBox(),),),
                              const SizedBox(height: Dimensions.paddingSizeSmall),
                            ],),
                          );
                        }
                    ),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(
                        hintText: 'description'.tr,
                        controller: expenseDescriptionController,
                        inputAction: TextInputAction.next,
                        focusNode: accountDescriptionNode,
                        nextFocus: accountBalanceNode,),
                      title: 'description'.tr,
                      requiredField: true,
                    ),



                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(
                          hintText: 'init_balance_hint'.tr,
                          controller: expenseAmountController,
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.number),
                      title: 'amount'.tr,
                      requiredField: true,
                    ),

                    InkWell(
                      onTap: ()=> selectDate(context),
                      child: CustomFieldWithTitleWidget(
                        customTextField: CustomTextFieldWidget(
                          hintText: '2022-05-17'.tr,
                          controller: expenseDateController,
                          suffix: true,
                          suffixIcon: Images.calender,
                          isEnabled: false,
                          inputAction: TextInputAction.done,

                        ),
                        title: 'date'.tr,
                        requiredField: true,
                      ),
                    ),
                  ]),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButtonWidget(
                  isLoading: expenseController.isLoading,
                  buttonText:update ? 'update'.tr : 'save'.tr,
                  onPressed: () async {
                    String description = expenseDescriptionController.text.trim();
                    String balance = expenseAmountController.text.trim();
                    String expenseDate = selectedDate.toString();
                    int? accountIdNumber = Get.find<TransactionController>().fromAccountIndex;


                    if(description.isEmpty){
                      showCustomSnackBarHelper('expense_description_required'.tr);
                    }else if(balance.isEmpty){
                      showCustomSnackBarHelper('expense_balance_required'.tr);
                    }else if(double.parse(balance) < 0){
                      showCustomSnackBarHelper('balance_should_be_greater_than_0'.tr);
                    }else if(expenseDate.isEmpty){
                      showCustomSnackBarHelper('expense_date_required'.tr);
                    }else if(accountIdNumber == null){
                      showCustomSnackBarHelper('select_account'.tr.tr);
                    }else{


                      if(widget.fromIncome){
                        Incomes income = Incomes(
                            accountId: accountIdNumber,
                            description: description,
                            amount: double.parse(balance),
                            date: expenseDate
                        );
                        Get.find<IncomeController>().addIncome(income);
                      }else{
                        Expenses expense = Expenses(
                          id: widget.expense?.id,
                          accountId: accountIdNumber,
                          description:  description,
                          amount: double.parse(balance),
                          date: expenseDate,
                        );

                        await expenseController.addExpense(expense, update);
                      }

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
