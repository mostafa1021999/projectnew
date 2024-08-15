import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/features/order/domain/models/invoice_model.dart';
import 'package:six_pos/features/order/screens/order_invoice_print_screen.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_divider.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import '../widgets/invoice_element_widget.dart';

class InVoiceScreen extends StatefulWidget {
  final int? orderId;
  const InVoiceScreen({Key? key, this.orderId}) : super(key: key);

  @override
  State<InVoiceScreen> createState() => _InVoiceScreenState();
}

class _InVoiceScreenState extends State<InVoiceScreen> {
  Future<void> _loadData() async {
    await Get.find<OrderController>().getInvoiceData(widget.orderId);
  }
  double totalPayableAmount = 0;


  @override
  void initState() {
    _loadData();
    super.initState();
  }

  double _getTotalPayableAmount(Invoice? invoice, double taxAmount) {
   return totalPayableAmount = (invoice?.orderAmount ?? 0) + taxAmount - (invoice?.extraDiscount ?? 0) - (invoice?.couponDiscountAmount ?? 0);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: GetBuilder<SplashController>(
        builder: (shopController) {

          return SingleChildScrollView(
            child: GetBuilder<OrderController>(
              builder: (invoiceController) {
                totalPayableAmount = _getTotalPayableAmount(invoiceController.invoice, invoiceController.totalTaxAmount);

                return Column(children: [
                  CustomHeaderWidget(title: 'invoice'.tr, headerImage: Images.peopleIcon),

                  Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                    child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      const Expanded(flex: 3,child: SizedBox.shrink()),
                      Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Container(width: 80,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                            color: Theme.of(context).primaryColor,

                          ),
                          child: InkWell(
                            onTap: (){
                             Get.to(OrderInvoicePrintScreen(configModel: shopController.configModel,
                                 invoice : invoiceController.invoice,
                                 orderId: widget.orderId,
                               discountProduct: invoiceController.discountOnProduct,
                               total: totalPayableAmount,
                             ));
                            },
                            child: Center(child: Row(
                              children: [
                                Icon(Icons.event_note_outlined, color: Theme.of(context).cardColor, size: 15,),
                                const SizedBox(width: Dimensions.paddingSizeMediumBorder),
                                Text('print'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor),),
                              ],
                            )),
                          ),),
                      ),

                    ],),
                  ),

                  Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    Text(shopController.configModel?.businessInfo?.shopName ?? '',
                      style: fontSizeBold.copyWith(color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeOverOverLarge,),),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),



                    Text(shopController.configModel?.businessInfo?.shopAddress ?? '',
                      style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                    Text(shopController.configModel?.businessInfo?.shopPhone ?? '',
                      style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),


                    Text(shopController.configModel?.businessInfo?.shopEmail ?? '',
                      style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                    Text(shopController.configModel?.businessInfo?.vat ?? '',
                      style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

                  ]),


                  GetBuilder<OrderController>(
                    builder: (orderController) {

                      return orderController.invoice?.orderAmount != null ?
                        Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Column(children: [
                          CustomDividerWidget(color: Theme.of(context).hintColor),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${'invoice'.tr.toUpperCase()} # ${widget.orderId}', style: fontSizeBold.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.fontSizeLarge)),

                            Text('payment_method'.tr, style: fontSizeBold.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: Dimensions.fontSizeLarge)),
                          ],),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(DateConverterHelper.dateTimeStringToMonthAndTime(orderController.invoice!.createdAt!),
                                style: fontSizeRegular),

                            Text('${'paid_by'.tr} ${invoiceController.invoice?.account?.account}', style: fontSizeRegular.copyWith(
                              color: Theme.of(context).hintColor,
                              fontSize: Dimensions.fontSizeDefault,
                            )),
                          ],),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          CustomDividerWidget(color: Theme.of(context).hintColor),
                          const SizedBox(height: Dimensions.paddingSizeLarge),


                          InvoiceElementWidget(serial: 'sl'.tr, title: 'product_info'.tr, quantity: 'qty'.tr, price: 'price'.tr, isBold: true),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          ListView.builder(
                            itemBuilder: (con, index){

                              return SizedBox(height: 50,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text((index+1).toString()),
                                      const SizedBox(width: Dimensions.paddingSizeDefault),
                                      Expanded(
                                          child: Text(jsonDecode(orderController.invoice!.details![index].productDetails!)['name'],
                                            maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                                        child: Text(orderController.invoice!.details![index].quantity.toString()),
                                      ),

                                      Text(PriceConverterHelper.priceWithSymbol(orderController.invoice!.details![index].price!)),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: orderController.invoice!.details!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
                            child: CustomDividerWidget(color: Theme.of(context).hintColor),
                          ),


                          Column(children: [

                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text('subtotal'.tr,style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              Text(PriceConverterHelper.priceWithSymbol(orderController.subTotalProductAmount)),
                            ],),
                            const SizedBox(height: Dimensions.paddingSizeSmall),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text('product_discount'.tr,style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              Text(PriceConverterHelper.priceWithSymbol(invoiceController.discountOnProduct)),
                            ],),
                            const SizedBox(height: Dimensions.paddingSizeSmall),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text('coupon_discount'.tr,style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              Text(PriceConverterHelper.priceWithSymbol(orderController.invoice!.couponDiscountAmount!)),
                            ],),
                            const SizedBox(height: Dimensions.paddingSizeSmall),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text('extra_discount'.tr,style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              Text(PriceConverterHelper.priceWithSymbol(orderController.invoice!.extraDiscount!)),
                            ],),
                            const SizedBox(height: Dimensions.paddingSizeSmall),


                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                              Text('tax'.tr,style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                              Text(PriceConverterHelper.priceWithSymbol(invoiceController.totalTaxAmount)),
                            ],),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                          ],),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                            child: CustomDividerWidget(color: Theme.of(context).hintColor),
                          ),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Text('total'.tr,style: fontSizeBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge),),
                            Text(PriceConverterHelper.priceWithSymbol(totalPayableAmount),
                                style: fontSizeBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                          ],),
                          const SizedBox(height: Dimensions.paddingSizeDefault),


                          if(orderController.invoice?.account?.account?.toLowerCase() == 'cash') Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                            Text('change'.tr,style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                            Text(PriceConverterHelper.priceWithSymbol(orderController.invoice!.collectedCash! - totalPayableAmount),
                                style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                          ],),
                          const SizedBox(height: Dimensions.paddingSizeDefault),



                          Column(children: [
                            Text('terms_and_condition'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                            Text('terms_and_condition_details'.tr, maxLines:2,textAlign: TextAlign.center,
                              style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
                          ],),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
                            child: CustomDividerWidget(color: Theme.of(context).hintColor),
                          ),

                          Column(children: [
                            Text('${'powered_by'.tr} ${shopController.configModel?.businessInfo?.shopName ?? ''}', style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                            const SizedBox(height: Dimensions.paddingSizeSmall,),
                            Text('${'shop_online'.tr} ${shopController.configModel?.businessInfo?.shopName ?? ''}', maxLines:2,textAlign: TextAlign.center,
                              style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
                          ],),

                          const SizedBox(height: Dimensions.paddingSizeCustomBottom),

                        ],),
                      ):const SizedBox();
                    }
                  ),







                ],);
              }
            ),
          );
        }
      ),
    );
  }
}
