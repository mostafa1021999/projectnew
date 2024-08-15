import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/user/controllers/customer_controller.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/common/models/customer_model.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_date_picker_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';

class AddBalanceDialogWidget extends StatefulWidget {
  final Customers? customer;
  const AddBalanceDialogWidget({Key? key, this.customer}) : super(key: key);

  @override
  State<AddBalanceDialogWidget> createState() => _AddBalanceDialogWidgetState();
}

class _AddBalanceDialogWidgetState extends State<AddBalanceDialogWidget> {
  TextEditingController addBalanceAmountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addBalanceDateController = TextEditingController();

  @override
  void initState() {
    Get.find<CustomerController>().clearDate();
    Get.find<TransactionController>().clearAccountIndex();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      child: GetBuilder<CustomerController>(
          builder: (customerController) {
            return Container(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment:CrossAxisAlignment.start,children: [

                Row(
                  children: [
                    Expanded(
                      child: CustomFieldWithTitleWidget(
                        customTextField: CustomTextFieldWidget(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                          ],
                          hintText: 'balance_hint'.tr,
                          controller:addBalanceAmountController,
                          inputType: TextInputType.number,
                        ),
                        title: 'balance'.tr,
                        requiredField: false,
                      ),
                    ),

                    Expanded(
                      child: GetBuilder<TransactionController>(
                          builder: (transactionController) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                              child: Container(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('balance_receive_account'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                        border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                                    child: DropdownButton<int>(
                                      hint: Text('select'.tr),
                                      value: transactionController.fromAccountIndex,
                                      items: transactionController.fromAccountIds?.map((int? value) {
                                        return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text(transactionController.accountList![(transactionController.fromAccountIds!.indexOf(value))].account!));}).toList(),
                                      onChanged: (int? value) {
                                        transactionController.setAccountIndex(value,'from', true);
                                      },
                                      isExpanded: true, underline: const SizedBox(),),),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                ],),),
                            );
                          }
                      ),
                    ),


                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomFieldWithTitleWidget(
                        customTextField: CustomTextFieldWidget(hintText: 'description'.tr,
                          controller: descriptionController,
                        ),
                        title: 'description'.tr,
                        requiredField: false,
                      ),
                    ),

                    Expanded(
                      child: CustomDatePickerWidget(
                        title: 'date'.tr,
                        text: customerController.startDate != null ?
                        customerController.dateFormat.format(customerController.startDate!).toString() : 'select_date'.tr,
                        image: Images.calender,
                        selectDate: () => customerController.selectDate("start", context),
                      ),
                    ),


                  ],
                ),




                const SizedBox(width: Dimensions.paddingSizeSmall),


                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Row(children: [
                    Expanded(child: CustomButtonWidget(
                      buttonText: 'cancel'.tr,
                      buttonColor: Theme.of(context).hintColor,
                      textColor: ColorResources.getTextColor(),
                      isClear: true,
                      onPressed: ()=> Get.back(),
                    )),

                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(child: customerController.isLoading ? const Center(child: CircularProgressIndicator()) : CustomButtonWidget(
                        buttonText: 'submit'.tr,onPressed: (){

                      String addBalanceAmount = addBalanceAmountController.text;
                      String description = descriptionController.text;
                      String? date;
                      if(customerController.startDate != null){
                        date  = customerController.dateFormat.format(customerController.startDate!).toString();
                      }

                      int? accountId = Get.find<TransactionController>().fromAccountIndex;

                      if(addBalanceAmount.isEmpty ){
                        showCustomSnackBarHelper('amount_cant_empty'.tr);
                      }else if(date == null){
                        showCustomSnackBarHelper('date_cant_empty'.tr);
                      }else{
                        customerController.updateCustomerBalance(widget.customer!.id, accountId, double.parse(addBalanceAmount), date,description);
                      }
                    }

                    )),
                  ],),
                )
              ],),);
          }
      ),
    );
  }
}


