import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

import '../../../common/controllers/cart_controller.dart';
import '../../../helper/price_converter_helper.dart';
class ItemPriceWidget extends StatefulWidget {
  final String? title;
  final String? extraDiscount;
  String? amount;
  dynamic total;
  final bool isTotal;
  final bool isCoupon;
  final Function? onTap;


  ItemPriceWidget({Key? key, this.title, this.amount, this.isTotal = false, this.isCoupon = false, this.onTap,this.extraDiscount,this.total}) : super(key: key);
  @override
  State<ItemPriceWidget> createState() => _ItemPriceWidgetState();
}

class _ItemPriceWidgetState extends State<ItemPriceWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
          Dimensions.paddingSizeExtraSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall),
      child: Row(children: [

        Text(widget.title!, style: fontSizeRegular.copyWith(color: widget.isTotal? Theme.of(context).primaryColor:
        ColorResources.getCheckoutTextColor(),fontWeight: widget.isTotal? FontWeight.w700: FontWeight.w500,
            fontSize: widget.isTotal? Dimensions.fontSizeLarge: Dimensions.paddingSizeDefault),),
        const Spacer(),
        widget.isCoupon?
        InkWell(
            onTap: widget.onTap as void Function()?,
            child: CircleAvatar(radius:10,backgroundColor: ColorResources.primaryColor,child: const Icon(Icons.edit,size: 17,color: Colors.white,))):const SizedBox(),
        if(widget.title=='vat'.tr||widget.title=='extra_discount'.tr)
    InkWell(
            onTap: widget.total,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Icon(Icons.close,color: Colors.white,size: 17,),
            ),
          ),
        SizedBox(width: 5,),
        Text( widget.amount!, style: fontSizeRegular.copyWith(color:  widget.isTotal? Theme.of(context).primaryColor:
        ColorResources.getCheckoutTextColor(),fontWeight:  widget.isTotal? FontWeight.w700: FontWeight.w500,
            fontSize:  widget.isTotal? Dimensions.fontSizeLarge: Dimensions.paddingSizeDefault),),

      ],),
    );
  }
}
