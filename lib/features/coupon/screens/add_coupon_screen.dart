import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/coupon/controllers/coupon_controller.dart';
import 'package:six_pos/features/coupon/domain/models/coupon_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_date_picker_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';

class AddCouponScreen extends StatefulWidget {
  final Coupons? coupon;
  const AddCouponScreen({Key? key, this.coupon}) : super(key: key);

  @override
  State<AddCouponScreen> createState() => _AddNewCouponScreenState();
}

class _AddNewCouponScreenState extends State<AddCouponScreen> {
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _couponCodeFocusNode = FocusNode();
  final FocusNode _limitForSameUserFocusNode = FocusNode();
  final FocusNode _minPurchaseFocusNode = FocusNode();
  final FocusNode _maxPurchaseFocusNode = FocusNode();
  final FocusNode _discountAmountFocusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _couponCodeController = TextEditingController();
  final TextEditingController _limitForSameUserController  = TextEditingController();
  final TextEditingController _minPurchaseController = TextEditingController();
  final TextEditingController _maxPurchaseController = TextEditingController();
  final TextEditingController _discountAmountController = TextEditingController();
  late bool update;
  String? selectedCouponType = 'default';
  String? selectedDiscountType = 'percent';

  @override
  initState(){
    super.initState();

    _initLoading();

  }

  @override
  void dispose(){
    _titleController.dispose();
    _couponCodeController.dispose();
    _limitForSameUserController.dispose();
    _minPurchaseController.dispose();
    _maxPurchaseController.dispose();
    _discountAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),
      appBar: const CustomAppBarWidget(isBackButtonExist: true),
      body: GetBuilder<CouponController>(
        builder:(couponController) => Column(children: [

          CustomHeaderWidget(title: !update? 'add_coupon'.tr : 'update_coupon'.tr, headerImage: Images.couponListIcon),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [

                CustomFieldWithTitleWidget(
                  title: 'title'.tr,
                  requiredField: true,
                  customTextField: CustomTextFieldWidget(
                    hintText: 'new_year_discount'.tr,
                    controller: _titleController,
                    focusNode: _titleFocusNode,
                    nextFocus: _couponCodeFocusNode,
                    inputType: TextInputType.text,
                  ),
                ),

                CustomFieldWithTitleWidget(
                  title: 'coupon_code'.tr,
                  requiredField: true,
                  customTextField: CustomTextFieldWidget(
                    hintText: 'new_year'.tr,
                    controller: _couponCodeController,
                    focusNode: _couponCodeFocusNode,
                    inputType: TextInputType.text,
                  ),
                  onTap: (){
                    _couponCodeController.text = _getGenerateCouponCode();

                  },
                ),

              Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('coupon_type'.tr,
                    style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

                    ),
                    child: DropdownButton<String>(
                      value: couponController.dropDownPosition == 0 ? 'default' : 'first_order',
                      items: <String>['default', 'first_order'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.tr),
                        );
                      }).toList(),
                      onChanged: (value) {
                        couponController.onChangeDropdownIndex(value == 'default' ? 0 : 1);
                        selectedCouponType = value;
                      },
                      isExpanded: true,
                      underline: const SizedBox(),
                    ),
                  ),
                ]),
              ),

               couponController.dropDownPosition == 0 ? CustomFieldWithTitleWidget(
                  title: 'limit_for_same_user'.tr,
                  requiredField: true,
                  customTextField: CustomTextFieldWidget(
                    hintText: 'limit_user_hint'.tr,
                    controller: _limitForSameUserController,
                    focusNode: _limitForSameUserFocusNode,
                    inputType: TextInputType.number,
                  ),
                ) : const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: CustomDatePickerWidget(
                        title: 'start_date'.tr,
                        text: couponController.startDate != null ?
                        couponController.dateFormat.format(couponController.startDate!).toString() : 'select_date'.tr,
                        image: Images.calender,
                        requiredField: true,
                        selectDate: () => couponController.selectDate("start", context),
                      ),
                    ),

                    Expanded(
                      child: CustomDatePickerWidget(
                        title: 'end_date'.tr,
                        text: couponController.endDate != null ?
                        couponController.dateFormat.format(couponController.endDate!).toString() : 'select_date'.tr,
                        image: Images.calender,
                        requiredField: true,
                        selectDate: () => couponController.selectDate("end", context),
                      ),
                    ),

                  ],),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      child: Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('discount_type'.tr,
                            style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

                            ),
                            child: DropdownButton<String>(
                              value: couponController.discountTypeIndex == 0 ? 'percent' : 'amount',
                              items: <String>['percent', 'amount'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.tr),
                                );
                              }).toList(),
                              onChanged: (value) {
                                couponController.setDiscountTypeIndex(value == 'percent' ? 0 : 1, true);
                                selectedDiscountType = value;
                              },
                              isExpanded: true,
                              underline: const SizedBox(),
                            ),
                          ),
                        ]),
                      ),
                    ),

                    Expanded(
                      child: CustomFieldWithTitleWidget(
                        title: 'discount_amount'.tr,
                        requiredField: true,
                        customTextField: CustomTextFieldWidget(
                          hintText: 'discount_amount_hint'.tr,
                          controller: _discountAmountController,
                          focusNode: _discountAmountFocusNode,
                          inputAction: TextInputAction.done,
                          inputType: TextInputType.number,
                        ),
                      ),
                    ),

                  ],),

                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Expanded(
                    child: CustomFieldWithTitleWidget(
                      title: 'min_purchase'.tr,
                      requiredField: true,
                      customTextField: CustomTextFieldWidget(
                        hintText: 'min_purchase_hint'.tr,
                        controller: _minPurchaseController,
                        focusNode: _minPurchaseFocusNode,
                        nextFocus: _maxPurchaseFocusNode,
                        inputType: TextInputType.number,
                      ),
                    ),
                  ),

                 if(couponController.discountTypeIndex == 0) Expanded(
                    child: CustomFieldWithTitleWidget(
                      title: 'max_discount'.tr,
                      requiredField: true,
                      customTextField: CustomTextFieldWidget(
                        hintText: 'max_discount_hint'.tr,
                        controller: _maxPurchaseController,
                        focusNode: _maxPurchaseFocusNode,
                        inputType: TextInputType.number,
                      ),
                    ),
                  ),
                ]),



              ],),
            ),
          ),

          CustomButtonWidget(
            margin: const EdgeInsets.only(
              left: Dimensions.paddingSizeDefault,
              right: Dimensions.paddingSizeDefault,
              bottom: Dimensions.paddingSizeDefault,
            ),
            buttonText: update? 'update'.tr : 'save'.tr,
            isLoading: couponController.isLoading,
            onPressed: (){
              _onSubmit();

            },
          ),

        ],),
      ),);
  }

  void _initLoading() {
    update = widget.coupon != null;
    if(update){
      _titleController.text = widget.coupon!.title!;
      _couponCodeController.text = widget.coupon!.couponCode!;
      _limitForSameUserController.text = widget.coupon!.userLimit.toString();
      _minPurchaseController.text = widget.coupon!.minPurchase.toString();
      _maxPurchaseController.text = widget.coupon!.maxDiscount.toString();
      _discountAmountController .text = widget.coupon!.discount.toString();
      selectedDiscountType = widget.coupon?.discountType;
      selectedCouponType = widget.coupon?.couponType;



      DateTime start =  DateTime.parse(widget.coupon!.startDate!);
      DateTime end =  DateTime.parse(widget.coupon!.startDate!);

      Get.find<CouponController>().setDate('start', start) ;
      Get.find<CouponController>().setDate('end', end) ;

      Get.find<CouponController>().setDiscountTypeIndex(widget.coupon!.discountType == 'percent'? 0:1, false) ;
      Get.find<CouponController>().onChangeDropdownIndex(selectedCouponType == 'default' ? 0 : 1, isUpdate: false);

    }else{
      Get.find<CouponController>().setDate('start', null) ;
      Get.find<CouponController>().setDate('end', null) ;
      Get.find<CouponController>().setDiscountTypeIndex(0, false) ;
    }
  }


  void _onSubmit() {
    final CouponController couponController = Get.find<CouponController>();

    String title = _titleController.text.trim();
    String couponCode = _couponCodeController.text.trim();
    String limitForSameUser = _limitForSameUserController.text.trim();
    String? startDate;
    String? endDate;


    if(update){
      startDate = widget.coupon!.startDate;
      endDate = widget.coupon!.expireDate;
    }else {
      if(couponController.startDate != null){
        startDate = couponController.dateFormat.format(couponController.startDate!);
      }

      if(couponController.endDate != null){
        endDate = couponController.dateFormat.format(couponController.endDate!);
      }
    }
    String minPurchase = _minPurchaseController.text.trim();
    String maxPurchase = _maxPurchaseController.text.trim();
    String discountAmount = _discountAmountController.text.trim();





    if(title.isEmpty){
      showCustomSnackBarHelper('enter_title'.tr);
    }else if(couponCode.isEmpty){
      showCustomSnackBarHelper('enter_coupon_code'.tr);
    }else if(couponController.dropDownPosition == 0 && limitForSameUser.isEmpty){
      showCustomSnackBarHelper('enter_limit_for_user'.tr);
    }else if(couponController.dropDownPosition == 0 && int.parse(limitForSameUser) < 1){
      showCustomSnackBarHelper('enter_minimum_1'.tr);
    }else if(startDate == null ){
      showCustomSnackBarHelper('enter_start_date'.tr);
    }else if(endDate == null){
      showCustomSnackBarHelper('enter_end_date'.tr);
    }else if(!(couponController.startDate!.isBefore(couponController.endDate!)
        || couponController.startDate!.isAtSameMomentAs(couponController.endDate!))){
      showCustomSnackBarHelper('select_valid_date_range'.tr);
    }else if(minPurchase.isEmpty){
      showCustomSnackBarHelper('enter_min_purchase'.tr);
    }else if( couponController.discountTypeIndex == 0 && maxPurchase.isEmpty){
      showCustomSnackBarHelper('enter_max_discount_amount'.tr);
    }else if(discountAmount.isEmpty){
      showCustomSnackBarHelper('enter_discount_amount'.tr);
    }else{
      Coupons coupon = Coupons(
        id: update? widget.coupon!.id: null,
        title: title,
        couponType: selectedCouponType,
        userLimit: int.tryParse(limitForSameUser),
        couponCode: couponCode,
        startDate: startDate,
        expireDate: endDate,
        minPurchase: minPurchase,
        maxDiscount: couponController.discountTypeIndex == 0 ?  maxPurchase : null,
        discount: discountAmount,
        discountType: selectedDiscountType,
      );
      couponController.addCoupon(coupon, update);

    }
  }

  String _getGenerateCouponCode() {
    const charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return String.fromCharCodes(List.generate(10, (index) => charset.codeUnitAt(random.nextInt(charset.length))));
  }

}
