import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/models/order_model.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/features/order/screens/invoice_screen.dart';
import 'package:six_pos/features/user/widgets/custom_divider_widget.dart';
class OrderCardWidget extends StatelessWidget {
  final Orders? order;
  const OrderCardWidget({Key? key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.03)),

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: Dimensions.paddingSizeExtraSmall),
          Text('${order!.id}', style: fontSizeRegular.copyWith(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: Dimensions.fontSizeLarge,
          )),
          const SizedBox(height: 5),

          Text(DateConverterHelper.dateTimeStringToMonthAndTime(order!.createdAt!),
            style: fontSizeRegular),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: CustomDividerWidget(color: Theme.of(context).hintColor),
          ),

          IntrinsicHeight(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Text('order_summary'.tr, style: fontSizeRegular.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeLarge,
                )),
                const SizedBox(height: 5),

                Text(
                  '${'order_amount'.tr}: ${PriceConverterHelper.priceWithSymbol(order!.orderAmount!)}',
                  style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 5),

                Text(
                  '${'tax'.tr}: ${PriceConverterHelper.priceWithSymbol(
                    double.tryParse(order!.totalTax.toString())!,
                  )}',
                  style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 5),

                Text(
                  '${'extra_discount'.tr}: ${PriceConverterHelper.priceWithSymbol(double.parse(order!.extraDiscount.toString()))}',
                  style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 5),

                Text(
                  '${'coupon_discount'.tr}: ${PriceConverterHelper.priceWithSymbol(
                    double.tryParse(order!.couponDiscountAmount.toString())!,
                  )}',
                  style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),
                ),
                const SizedBox(height: 5),

              ],),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('payment_method'.tr, style: fontSizeRegular.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.fontSizeLarge,
                    )),
                    const SizedBox(height: 5),

                    Text(order!.account != null ? order!.account!.account! : 'customer balance',
                      style: fontSizeRegular.copyWith(
                        color: Theme.of(context).hintColor,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ],),

                  CustomButtonWidget(
                    buttonText: 'invoice'.tr,
                    width: 120,
                    height: 40,
                    icon: Icons.event_note_outlined,
                    onPressed: () => Get.to(()=> InVoiceScreen(orderId: order!.id)),
                  ),
                ],),
            ],),),

          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        ],),),

      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.03)),
    ],);
  }
}
