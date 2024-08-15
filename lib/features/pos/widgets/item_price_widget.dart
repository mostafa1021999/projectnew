import 'package:flutter/material.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
class ItemPriceWidget extends StatelessWidget {
  final String? title;
  final String? amount;
  final bool isTotal;
  final bool isCoupon;
  final Function? onTap;
  const ItemPriceWidget({Key? key, this.title, this.amount, this.isTotal = false, this.isCoupon = false, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall),
      child: Row(children: [

        Text(title!, style: fontSizeRegular.copyWith(color: isTotal? Theme.of(context).primaryColor:
        ColorResources.getCheckoutTextColor(),fontWeight: isTotal? FontWeight.w700: FontWeight.w500,
            fontSize: isTotal? Dimensions.fontSizeLarge: Dimensions.paddingSizeDefault),),
        const Spacer(),
        isCoupon?
        InkWell(
          onTap: onTap as void Function()?,
            child: const Icon(Icons.edit)):const SizedBox(),

        Text(amount!, style: fontSizeRegular.copyWith(color: isTotal? Theme.of(context).primaryColor:
        ColorResources.getCheckoutTextColor(),fontWeight: isTotal? FontWeight.w700: FontWeight.w500,
            fontSize: isTotal? Dimensions.fontSizeLarge: Dimensions.paddingSizeDefault),),

      ],),
    );
  }
}