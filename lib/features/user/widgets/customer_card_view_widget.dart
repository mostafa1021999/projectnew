import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/user/controllers/customer_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/common/models/customer_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/common/widgets/custom_on_tap_widget.dart';
import 'package:six_pos/common/widgets/custom_dialog_widget.dart';
import 'package:six_pos/features/account_management/screens/transaction_list_screen.dart';
import 'package:six_pos/features/order/screens/order_screen.dart';
import 'package:six_pos/features/user/screens/add_new_user_screen.dart';
import 'package:six_pos/features/user/widgets/add_balance_dialog_widget.dart';
import 'package:six_pos/features/user/widgets/custom_divider_widget.dart';

class CustomerCardViewWidget extends StatelessWidget {
  final Customers? customer;
  const CustomerCardViewWidget({Key? key, this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
      Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeExtraSmall,
          horizontal: Dimensions.paddingSizeSmall,
        ),
        child: Column( crossAxisAlignment:CrossAxisAlignment.start, children: [
          Row(
            children: [
              CustomImageWidget(
                image: '${Get.find<SplashController>().configModel?.baseUrls?.customerImageUrl}/${customer?.image ?? ''}',
                width: 50, height: 50, fit: BoxFit.cover, placeholder: Images.profilePlaceHolder,
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(customer!.name!),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  Text('${'total_orders'.tr} : ${customer!.orderCount}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
                    Text('${'balance'.tr} : ${customer!.balance}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
                ],),
              ),
              customer!.id == 0? const SizedBox():
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: CustomOnTapWidget(child: Image.asset(Images.editIcon, height: 30), onTap: () {
                  Get.to(AddNewUserScreen(customer: customer, isCustomer: true,));
                },),
              ),

              customer!.id == 0? const SizedBox():
              GetBuilder<CustomerController>(
                builder: (customerController) {
                  return CustomOnTapWidget(child: Image.asset(Images.deleteIcon, height: 30), onTap: () {
                    showAnimatedDialogHelper(context,
                        CustomDialogWidget(
                          delete: true,
                          icon: Icons.exit_to_app_rounded, title: '',
                          description: 'are_you_sure_you_want_to_delete_customer'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                          onTapTrue:() {
                            customerController.deleteCustomer(customer!.id);
                          },
                          onTapTrueText: 'yes'.tr, onTapFalseText: 'cancel'.tr,
                        ),
                        dismissible: false,
                        isFlip: true);

                  },);
                }
              ),
            ],
          ),

          CustomDividerWidget(color: Theme.of(context).hintColor),

          Row(children: [
            Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding( padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                child: Text('contact_information'.tr, style: fontSizeMedium.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeLarge,
                )),
              ),

              Padding( padding: const EdgeInsets.only(bottom: 2),
                child: Text(customer!.email??'', style: fontSizeRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeSmall,
                )),
              ),

              Padding( padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(customer!.mobile!, style: fontSizeRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeSmall,
                )),
              ),
            ],),

            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end,children: [
              InkWell(
                onTap: ()=> Get.to(TransactionListScreen(fromCustomer: true,customerId: customer!.id)),
                child: Row(children: [
                  Text('transactions'.tr, style: fontSizeMedium.copyWith(color: Theme.of(context).primaryColor)),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  SizedBox(width: 20,height: 20,child: Image.asset(Images.item))
                ],),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall,),



              InkWell(
                onTap: ()=> Get.to(OrderScreen(isCustomer: true, customerId: customer!.id)),
                child: Row(children: [
                  Text('orders'.tr,style: fontSizeMedium.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  SizedBox(width: 20,height: 20,child: Image.asset(Images.stock,color: Theme.of(context).secondaryHeaderColor,))
                ],),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall,),

              customer!.id != 0?
              InkWell(
                onTap: (){
                  showAnimatedDialogHelper(context,
                      AddBalanceDialogWidget(customer: customer,),
                      dismissible: false,
                      isFlip: false);
                },

                child: Row(children: [
                  Text('add_balance'.tr,style: fontSizeMedium.copyWith(color: Theme.of(context).primaryColor),),
                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                  SizedBox(width: 20,height: 20,child: Image.asset(Images.dollar,color: Theme.of(context).primaryColor,))
                ],),
              ):const SizedBox(),
            ],)
          ],)
        ]),
      ),

    ],);
  }
}
