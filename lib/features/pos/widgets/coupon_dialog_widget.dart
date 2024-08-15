import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';

class CouponDialogWidget extends StatelessWidget {
  const CouponDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      child: GetBuilder<CartController>(
          builder: (cartController) {
            return Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              height: 250,child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [

                CustomFieldWithTitleWidget(
                  customTextField: CustomTextFieldWidget(hintText: 'coupon_code_hint'.tr,
                    controller:cartController.couponController,
                  ),
                  title: 'coupon_code'.tr,
                  requiredField: true,
                ),


                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Row(children: [
                    Expanded(child: CustomButtonWidget(buttonText: 'cancel'.tr,
                        buttonColor: Theme.of(context).hintColor,textColor: ColorResources.getTextColor(),isClear: true,
                        onPressed: ()=>Get.back())),
                    const SizedBox(width: Dimensions.paddingSizeDefault),
                    Expanded(child: CustomButtonWidget(buttonText: 'apply'.tr,onPressed: (){
                      if(cartController.couponController.text.trim().isNotEmpty){
                        cartController.getCouponDiscount(
                         cartController.couponController.text.trim(),
                          cartController.customerId,
                          cartController.amount,
                        );
                      }

                      Get.back();
                    },)),
                  ],),
                )
              ],),);
          }
      ),
    );
  }
}
