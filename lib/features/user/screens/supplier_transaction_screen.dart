import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/features/user/domain/models/supplier_model.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_date_picker_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/secondary_header_widget.dart';
import 'package:six_pos/features/user/widgets/purchase_dialog_widget.dart';
import 'package:six_pos/features/user/widgets/supplier_transaction_widget.dart';

class SupplierTransactionListScreen extends StatefulWidget {
  final int? supplierId;
  final Suppliers? supplier;
  const SupplierTransactionListScreen({Key? key, this.supplierId, this.supplier,}) : super(key: key);

  @override
  State<SupplierTransactionListScreen> createState() => _SupplierTransactionListScreenState();
}

class _SupplierTransactionListScreenState extends State<SupplierTransactionListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final SupplierController supplierController = Get.find<SupplierController>();
    supplierController.clearSelectedDate();

    supplierController.getSupplierTransactionList(1, widget.supplierId, isUpdate: false);
    supplierController.getSupplierProfile(widget.supplierId);

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
                child: Column(children: [
                  CustomHeaderWidget(title: 'transaction_List'.tr , headerImage: Images.peopleIcon),

                  GetBuilder<SupplierController>(
                      builder: (supplierController) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              IntrinsicHeight(child: Row(children: [
                                  Expanded(child: Container(
                                    padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall, Dimensions.paddingSizeSmall,0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor.withOpacity(.05),
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                        border: Border.all(color: Theme.of(context).primaryColor)
                                    ),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        supplierController.supplierProfile != null?
                                        Text(PriceConverterHelper.priceWithSymbol(supplierController.supplierProfile!.dueAmount ?? 0),
                                          style: fontSizeBold.copyWith(color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeLarge),):const SizedBox(),

                                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                        Text('due_amount'.tr, style: fontSizeMedium.copyWith(color: Theme.of(context).primaryColor),),
                                        Container(transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              const Spacer(),
                                              SizedBox(width: Dimensions.iconSizeSmall,height: Dimensions.iconSizeSmall,
                                                  child: Image.asset(Images.dollar, color: Theme.of(context).primaryColor,)),
                                            ],
                                          ),
                                        ),

                                      ],),)),
                                  const SizedBox(width: Dimensions.paddingSizeSmall),

                                  Expanded(
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            showAnimatedDialogHelper(context,
                                                PurchaseDialogWidget(supplier: widget.supplier,),
                                                dismissible: false,
                                                isFlip: false);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                                              color: Theme.of(context).secondaryHeaderColor,

                                            ),
                                            child: Center(child: Text('add_new_purchase'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor),)),),
                                        ),
                                        const SizedBox(height: Dimensions.paddingSizeSmall),
                                        InkWell(
                                          onTap: (){
                                            showAnimatedDialogHelper(context,
                                                PurchaseDialogWidget(fromPay: true,dueAmount: supplierController.supplierProfile!.dueAmount ?? 0, supplier: widget.supplier),
                                                dismissible: false,
                                                isFlip: false);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                                              color: Theme.of(context).primaryColor,

                                            ),
                                            child: Center(child: Text('pay'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor),)),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ])),

                              const SizedBox(height: Dimensions.paddingSizeDefault),
                              Row(children: [
                                Expanded(
                                  child: CustomDatePickerWidget(
                                    title: 'from'.tr,
                                    text: supplierController.startDate != null ?
                                    supplierController.dateFormat.format(supplierController.startDate!).toString() : 'from_date'.tr,
                                    image: Images.calender,
                                    requiredField: false,
                                    selectDate: () => supplierController.selectDate("start", context),
                                  ),
                                ),

                                Expanded(
                                  child: CustomDatePickerWidget(
                                    title: 'to'.tr,
                                    text: supplierController.endDate != null ?
                                    supplierController.dateFormat.format(supplierController.endDate!).toString() : 'to_date'.tr,
                                    image: Images.calender,
                                    requiredField: false,
                                    selectDate: () => supplierController.selectDate("end", context),
                                  ),
                                ),

                              ],),

                              const SizedBox(height: Dimensions.paddingSizeSmall),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0,0,Dimensions.paddingSizeDefault,0),
                                child: Row(mainAxisAlignment : MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        if(supplierController.startDate == null || supplierController.endDate == null) {
                                          showCustomSnackBarHelper('select_date_range_first'.tr);

                                        }else {

                                          supplierController.getSupplierTransactionFilterList(1,widget.supplierId, supplierController.startDate!, supplierController.endDate!);
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                                          color: Theme.of(context).primaryColor,

                                        ),
                                        child: Center(child: Text('filter'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor),)),),
                                    ),
                                  ],
                                ),
                              ),


                            ],
                          ),
                        );
                      }
                  ),


                  SecondaryHeaderWidget(isSerial: true, key: UniqueKey(),isTransaction: true, title: 'transaction_info'.tr,),

                  SupplierTransactionListWidget(scrollController: _scrollController, supplier: widget.supplier)


                ]),
              )
            ],
          ),
        ),
      ),


    );
  }
}
