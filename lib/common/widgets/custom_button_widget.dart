import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onPressed;
  final String? buttonText;
  final Color? buttonColor;
  final Color? textColor;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;
  final bool isClear;
  final bool isLoading;
  const CustomButtonWidget({Key? key,
    this.onPressed,
    required this.buttonText,
    this.buttonColor,
    this.textColor,
    this.margin,
    this.width,
    this.height,
    this.fontSize,
    this.radius = 5,
    this.icon,
    this.isClear =  false, this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onPressed == null ?
        Theme.of(context).disabledColor : buttonColor ?? Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width! : Dimensions.webMaxWidth, height != null ? height! : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );

    return Center(child: SizedBox(width: width ?? Dimensions.webMaxWidth, child: Padding(
      padding: margin == null ? const EdgeInsets.all(0) : margin!,
      child: TextButton(
        onPressed: isLoading ? null : onPressed as void Function()?,
        style: flatButtonStyle,
        child: isLoading ?
        Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 15, width: 15,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2,
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeSmall),

          Text('loading'.tr, style: fontSizeRegular.copyWith(color: Colors.white)),
        ]),
        ) : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon != null ? Padding(
            padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
            child: Icon(icon, color: Theme.of(context).cardColor),
          ) : const SizedBox(),
          Text(buttonText ??'', textAlign: TextAlign.center, style: fontSizeRegular.copyWith(
            color: isClear? textColor : Theme.of(context).cardColor,
            fontSize: fontSize ?? Dimensions.fontSizeDefault,
          )),
        ]),
      ),
    )));
  }
}