import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/user/controllers/customer_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/common/models/customer_model.dart';
import 'package:six_pos/features/user/domain/models/supplier_model.dart';
import 'package:six_pos/helper/email_checker.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';

class CreateUserScreen extends StatefulWidget {
  final bool isCustomer;
  final Suppliers? supplier;
  final Customers? customer;
  const CreateUserScreen({Key? key, this.isCustomer = false, this.supplier, this.customer}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {

  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierPhoneNumber = TextEditingController();
  TextEditingController supplierEmail = TextEditingController();
  TextEditingController supplierCity = TextEditingController();
  TextEditingController supplierZip = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  late bool customerUpdate, supplierUpdate;
  @override
  void initState() {
    super.initState();

    customerUpdate =  widget.customer != null;
    supplierUpdate = widget.supplier != null;
    if(customerUpdate){
      supplierNameController.text = widget.customer?.name ?? '';
      supplierPhoneNumber.text = widget.customer?.mobile ?? '';
      supplierEmail.text = widget.customer?.email ?? '';
      supplierCity.text = widget.customer?.city ?? '';
      supplierZip.text = widget.customer?.zipCode ?? '';
    }else if(supplierUpdate){
      supplierNameController.text = widget.supplier?.name ?? '';
      supplierPhoneNumber.text = widget.supplier?.mobile ?? '';
      supplierEmail.text = widget.supplier?.email ?? '';
      supplierCity.text = widget.supplier?.city ?? '';
      supplierZip.text = widget.supplier?.zipCode ?? '';
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),

      appBar: const CustomAppBarWidget(isBackButtonExist: true),

      body: GetBuilder<SupplierController>(builder: (supplierController) {
        return GetBuilder<CustomerController>(builder: (customerController) {
          return Column(children: [
            CustomHeaderWidget(
              title: 'create_new_account'.tr,
              headerImage: Images.addIcon,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'enter_user_name'.tr,
                      controller: supplierNameController,
                    ),
                    title: 'user_name'.tr,
                    requiredField: true,
                  ),

                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'enter_phone_number'.tr,
                      controller: supplierPhoneNumber,
                      inputType: TextInputType.phone,
                    ),
                    title: 'phone_number'.tr,
                    requiredField: true,
                  ),

                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'enter_email_address'.tr,
                      controller: supplierEmail,),
                    title: 'email'.tr,
                    requiredField: true,
                  ),

                  Row(children: [
                    Expanded(child: CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'enter_city_name'.tr,
                        controller: supplierCity,),
                      title: 'city'.tr,
                      requiredField: true,
                    ),),

                    Expanded(child: CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'enter_zip_code'.tr,
                        controller: supplierZip,),
                      title: 'zip'.tr,
                      requiredField: true,
                    ),),
                  ]),
                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'enter_password'.tr,
                      controller: password,
                      inputType: TextInputType.visiblePassword,
                    ),
                    title: 'password'.tr,
                    requiredField: true,
                  ),
                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'enter_password'.tr,
                      controller: confirmPassword,
                      inputType: TextInputType.visiblePassword,
                    ),
                    title: 'confirm_password'.tr,
                    requiredField: true,
                  ),
                ]),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonWidget(
                isLoading: supplierController.isLoading || customerController.isLoading,
                buttonText: 'create_account'.tr,
                onPressed: (){
                  String supplierName = supplierNameController.text.trim();
                  String supplierMobile = supplierPhoneNumber.text.trim();
                  String supplierEmailAddress = supplierEmail.text.trim();
                  String city = supplierCity.text.trim();
                  String passwordData = password.text.trim();
                  String supplierZipData=supplierZip.text.trim();
                  String confirmPasswordData = confirmPassword.text.trim();
                  if(supplierName.isEmpty){
                    showCustomSnackBarHelper('enter_user_name'.tr);
                  }else if(supplierMobile.isEmpty){
                    showCustomSnackBarHelper('mobile_required'.tr);
                  }else if(supplierEmailAddress.isEmpty){
                    showCustomSnackBarHelper('enter_email_address'.tr);
                  }
                  else if(EmailCheckerHelper.isNotValid(supplierEmailAddress)){
                    showCustomSnackBarHelper('enter_valid_email'.tr);
                  }else if(city.isEmpty){
                    showCustomSnackBarHelper('city_required'.tr);
                  }else if(supplierZipData.isEmpty){
                    showCustomSnackBarHelper('zip_required'.tr);
                  }else if(passwordData.isEmpty||passwordData.length<8){
                    showCustomSnackBarHelper('enter_8_digit_password'.tr);
                  }else if(confirmPasswordData!=passwordData){
                    showCustomSnackBarHelper('password_not_match'.tr);
                  }
                },
              ),
            ),
          ]);
        });
      }),
    );
  }
}
