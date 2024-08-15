
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/account_controller.dart';
import 'package:six_pos/common/models/account_model.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/features/account_management/domain/models/transaction_type_model.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_date_picker_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/secondary_header_widget.dart';
import 'package:six_pos/features/account_management/widgets/customer_transaction_list_widget.dart';
import 'package:six_pos/features/account_management/widgets/transaction_list_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionListScreen extends StatefulWidget {
  final bool fromCustomer;
  final int? customerId;
  const TransactionListScreen({Key? key, this.fromCustomer = false, this.customerId}) : super(key: key);

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final ScrollController _scrollController = ScrollController();




  @override
  void initState() {
    final TransactionController transactionController =  Get.find<TransactionController>();
    final AccountController accountController =  Get.find<AccountController>();
    if(widget.fromCustomer){
     transactionController.getCustomerWiseTransactionListList(widget.customerId, 1, isUpdate: false);
    }else{
      transactionController.getTransactionList(1, isUpdate: false);
    }
    accountController.setAccountIndex(null, false);


    transactionController.getTransactionTypeList();
    transactionController.resetDate(isUpdate: false);
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(isBackButtonExist: true),
      endDrawer: const CustomDrawerWidget(),
      body: SafeArea(
        child: CustomScrollView(
          controller: Get.find<TransactionController>().scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(children: [
                CustomHeaderWidget(title: 'transaction_List'.tr , headerImage: Images.peopleIcon),

                GetBuilder<TransactionController>(
                    builder: (transactionController) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
                            GetBuilder<AccountController>(
                                builder: (accountController) {
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Text('account'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),
                                        Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                                          decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                              border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                                          child: DropdownButton<int>(
                                            hint: Text('select'.tr),
                                            value: accountController.selectedAccountId,
                                            items: accountController.accountModel?.accountList?.map((Accounts? value) {
                                              return DropdownMenuItem<int>(
                                                  value: value?.id,
                                                  child: Text(value?.account ?? ''));
                                            }).toList(),
                                            onChanged: (int? value) {
                                              accountController.setAccountIndex(value, true);
                                            },
                                            isExpanded: true, underline: const SizedBox(),),),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),
                                      ],),
                                    ),
                                  );
                                }
                            ),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('transaction_type'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),

                                  Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                        border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                                    child: DropdownButton<int>(
                                      hint: Text('select'.tr),
                                      value: transactionController.transactionTypeId,
                                      items: transactionController.transactionTypeModel?.typeList?.map((Types? value) {
                                        return DropdownMenuItem<int>(
                                            value: value?.id,
                                            child: Text(value?.tranType ?? ''));
                                      }).toList(),
                                      onChanged: (int? value) {
                                        transactionController.setTransactionTypeIndex(value, true);
                                      },
                                      isExpanded: true, underline: const SizedBox(),),),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                ],),
                              ),
                            ),

                          ],),

                          Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
                            Expanded(
                              child: CustomDatePickerWidget(
                                title: 'from'.tr,
                                text: transactionController.startDate != null ?
                                transactionController.dateFormat.format(transactionController.startDate!).toString() : 'from_date'.tr,
                                image: Images.calender,
                                requiredField: false,
                                selectDate: () => transactionController.selectDate("start", context),
                              ),
                            ),

                            Expanded(
                              child: CustomDatePickerWidget(
                                title: 'to'.tr,
                                text: transactionController.endDate != null ?
                                transactionController.dateFormat.format(transactionController.endDate!).toString() : 'to_date'.tr,
                                image: Images.calender,
                                requiredField: false,
                                selectDate: () => transactionController.selectDate("end", context),
                              ),
                            ),

                          ],),

                          Row(children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  _launchUrl(Uri.parse('${AppConstants.baseUrl}${AppConstants.transactionListExportUri}'));
                                  _launchUrl(Uri.parse('${AppConstants.baseUrl}${AppConstants.transactionListExportUri}?'
                                      'from=${transactionController.startDate.toString()}&to=${transactionController.endDate.toString()}&account_id=0&transaction_type='));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                                      color: Theme.of(context).secondaryHeaderColor,

                                    ),
                                    child: Center(child: Text('export'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor),)),),
                                ),
                              ),
                            ),

                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  transactionController.getTransactionList(1);
                                  transactionController.resetDate();

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                                      color: ColorResources.getCategoryWithProductColor(),

                                    ),
                                    child: Center(child: Text('reset'.tr, style: fontSizeRegular.copyWith(color: ColorResources.getTextColor()),)),),
                                ),
                              ),
                            ),

                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  String selectedStartDate = '';
                                  String selectedEndDate = '';


                                  if((transactionController.startDate != null && transactionController.endDate == null)
                                      ||  transactionController.endDate != null && transactionController.startDate == null){

                                    showCustomSnackBarHelper('select_from_and_to_date'.tr);
                                  }
                                  else{

                                    if(transactionController.startDate != null && transactionController.endDate != null){
                                      selectedStartDate = transactionController.dateFormat.format(transactionController.startDate!).toString();
                                      selectedEndDate = transactionController.dateFormat.format(transactionController.endDate!).toString();
                                    }

                                    if(transactionController.startDate == null
                                        && Get.find<AccountController>().selectedAccountId == null
                                        && transactionController.transactionTypeName == null) {

                                      showCustomSnackBarHelper('select_any_field_to_filter'.tr);

                                    }else {
                                      transactionController.getTransactionFilter(
                                        selectedStartDate, selectedEndDate,
                                        Get.find<AccountController>().selectedAccountId,
                                        transactionController.transactionTypeName, 1,
                                      );
                                    }
                                  }



                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                                      color: Theme.of(context).primaryColor,

                                    ),
                                    child: Center(child: Text('filter'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor),)),),
                                ),
                              ),
                            ),
                          ]),
                        ]),
                      );
                    }
                ),


                SecondaryHeaderWidget(isSerial: true, key: UniqueKey(),isTransaction: true, title: 'transaction_info'.tr,),


                widget.fromCustomer ? CustomerTransactionListWidget(
                  isHome: false,scrollController: _scrollController,
                  customerId: widget.customerId,
                ) : const TransactionListWidget(isHome: false,)


              ]),
            )
          ],
        ),
      ),



    );
  }
}


Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}