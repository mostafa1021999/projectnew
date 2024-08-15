import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class SecondaryHeaderWidget extends StatelessWidget {
  final bool isSerial;
  final bool isLimited;
  final String? title;
  final bool isTransaction;
  final bool showOwnTitle;
  const SecondaryHeaderWidget({Key? key, this.isSerial = false, this.isLimited = false, this.title, this.isTransaction = false, this.showOwnTitle = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.06),
      child: ListTile(
        title: showOwnTitle? const SizedBox(): isTransaction? Text(title!) : isSerial ? Text('item_info'.tr, style: fontSizeMedium.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.fontSizeLarge,
          )) : const SizedBox(),

        leading:showOwnTitle && isSerial? Text(title!,style: fontSizeMedium.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: Dimensions.fontSizeLarge,
        )) : isSerial ? Text('#', style: fontSizeMedium.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: Dimensions.fontSizeLarge,
        ),) : Text('item_info'.tr, style: fontSizeMedium.copyWith(
          color: Theme.of(context).primaryColor,
          fontSize: Dimensions.fontSizeLarge,
        )),

        trailing: isTransaction? const SizedBox() : Padding(
          padding: isLimited? const EdgeInsets.only(right: Dimensions.paddingSizeExtraLarge): const EdgeInsets.only(right: 0.0),
          child: Text(isLimited?'qty'.tr : 'action'.tr, style: fontSizeMedium.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.fontSizeLarge,
          )),
        ),

      ),
    );
  }
}