import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomFieldWithTitleWidget extends StatelessWidget {
  final Widget customTextField;
  final String? title;
  final bool requiredField;
  final bool isPadding;
  final bool limitSet;
  final String? setLimitTitle;
  final Function? onTap;
  final String? toolTipsMessage;
  const CustomFieldWithTitleWidget({
    Key? key,
    required this.customTextField,
    this.title,
    this.setLimitTitle,
    this.requiredField = false,
    this.isPadding = true,
    this.limitSet = false,
    this.onTap,
    this.toolTipsMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isPadding ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      child: Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: title, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
                    children: <TextSpan>[
                     requiredField ? TextSpan(text: '  *', style: fontSizeBold.copyWith(color: Colors.red)) : const TextSpan(),
                    ],
                  ),
                ),

               if(toolTipsMessage != null) Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  child: PopupMenuButton(
                    icon: Icon(Icons.info_outline, size: 20, color: Theme.of(context).primaryColor),
                    tooltip: toolTipsMessage,
                    color: const Color(0xFF36454F),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.radiusLarge))
                    ),

                    itemBuilder: (BuildContext bc) {
                      return [
                        PopupMenuItem(child: Text(
                          toolTipsMessage!,
                          style: fontSizeLight.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                        )),

                      ];
                    },
                  ),
                )
              ],
            ),

           if(onTap != null) InkWell(
             onTap: onTap as void Function()?,
             child: Text(
               limitSet? setLimitTitle! : 'auto_generate'.tr,
               style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),
             ),
            ),
          ],
        ),
        // if(showTooltip) Text('(To decrease product quantity use minus before number. Ex: -10 )', style: fontSizeLight.copyWith(color: Theme.of(context).hintColor)),

        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
        
        customTextField,
      ],),
    );
  }
}
