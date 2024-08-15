import 'package:flutter/material.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

import 'custom_button_widget.dart';

class CustomDialogWidget extends StatelessWidget {
  final bool isFailed;
  final double rotateAngle;
  final IconData icon;
  final bool delete;
  final String title;
  final String description;
  final Function onTapTrue;
  final String? onTapTrueText;
  final Function onTapFalse;
  final String? onTapFalseText;
  final bool isLoading;
  const CustomDialogWidget({Key? key, this.isFailed = false, this.rotateAngle = 0, required this.icon, required this.title,
    required this.description,required this.onTapFalse,required this.onTapTrue, this.onTapTrueText,
    this.onTapFalseText, this.delete = false, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Stack(clipBehavior: Clip.none, children: [

          Positioned(
            left: 0, right: 0, top: delete? 0 : -55,
            child: Container(
              height: delete ? 50: 80,
              width: delete ? 50 : 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: delete ? ColorResources.getRedColor() : isFailed ?
              ColorResources.getRedColor() : Theme.of(context).primaryColor,
                  shape: BoxShape.circle),
              child: Transform.rotate(angle: rotateAngle, child: delete ? SizedBox(width: Dimensions.iconSizeLarge,
                  child: Image.asset(Images.deleteIcon, color: Theme.of(context).cardColor,)):Icon(icon, size: 40,
                  color: delete ? Theme.of(context).secondaryHeaderColor :Colors.white)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(title, style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeLarge)),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(description, textAlign: TextAlign.center, style: fontSizeRegular),
              const SizedBox(height: Dimensions.paddingSizeLarge),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  children: [

                    Expanded(child: CustomButtonWidget(buttonText: onTapFalseText,
                         isClear: true,
                         textColor: Theme.of(context).primaryColor,
                         buttonColor: Theme.of(context).hintColor,
                         onPressed: onTapFalse)),
                    const SizedBox(width: 10,),

                    Expanded(child: CustomButtonWidget(
                      isLoading: isLoading,
                        buttonText: onTapTrueText,
                      onPressed: onTapTrue)),
                  ],
                ),
              ),
            ]),
          ),

        ]),
      ),
    );
  }
}
