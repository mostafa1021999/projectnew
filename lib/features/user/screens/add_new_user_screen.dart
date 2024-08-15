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

class AddNewUserScreen extends StatefulWidget {
  final bool isCustomer;
  final Suppliers? supplier;
  final Customers? customer;
  const AddNewUserScreen({Key? key, this.isCustomer = false, this.supplier, this.customer}) : super(key: key);

  @override
  State<AddNewUserScreen> createState() => _AddNewUserScreenState();
}

class _AddNewUserScreenState extends State<AddNewUserScreen> {

  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierPhoneNumber = TextEditingController();
  TextEditingController supplierEmail = TextEditingController();
  TextEditingController supplierState = TextEditingController();
  TextEditingController supplierCity = TextEditingController();
  TextEditingController supplierZip = TextEditingController();
  TextEditingController supplierAddress = TextEditingController();

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
      supplierState.text = widget.customer?.state ?? '';
      supplierCity.text = widget.customer?.city ?? '';
      supplierZip.text = widget.customer?.zipCode ?? '';
      supplierAddress.text = widget.customer ?.address ?? '';
    }else if(supplierUpdate){
      supplierNameController.text = widget.supplier?.name ?? '';
      supplierPhoneNumber.text = widget.supplier?.mobile ?? '';
      supplierEmail.text = widget.supplier?.email ?? '';
      supplierState.text = widget.supplier?.state ?? '';
      supplierCity.text = widget.supplier?.city ?? '';
      supplierZip.text = widget.supplier?.zipCode ?? '';
      supplierAddress.text = widget.supplier?.address ?? '';
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
              title:  widget.isCustomer && customerUpdate
                  ? 'update_customer'.tr : widget.isCustomer && !customerUpdate
                  ? 'add_new_customer'.tr : supplierUpdate
                  ? 'update_supplier'.tr : 'add_new_supplier'.tr,
              headerImage: Images.addIcon,
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText:  widget.isCustomer?  'enter_customer_name'.tr : 'enter_supplier_name'.tr,
                      controller: supplierNameController,
                    ),
                    title: widget.isCustomer?  'customer_name'.tr :'supplier_name'.tr,
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

                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'enter_state'.tr,
                      controller: supplierState,),
                    title: 'state'.tr,
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
                    customTextField: CustomTextFieldWidget(hintText: 'enter_address'.tr, maxLines: 5,
                      controller: supplierAddress,
                    ),
                    title: 'address'.tr,
                    requiredField: true,
                  ),

                  Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeSmall,
                          horizontal: Dimensions.paddingSizeDefault,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: 'image'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
                            children: <TextSpan>[
                              TextSpan(text:' ${'ratio'.tr}', style: fontSizeBold.copyWith(color: Theme.of(context).colorScheme.error)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  customerUpdate || widget.isCustomer?
                  GetBuilder<CustomerController>(
                      builder: (customerController) {
                        return Align(alignment: Alignment.center, child: Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            child: customerController.customerImage != null ?  Image.file(File(customerController.customerImage!.path),
                              width: 150, height: 120, fit: BoxFit.cover,
                            ) :widget.customer!=null? FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              image: '${Get.find<SplashController>().configModel?.baseUrls?.customerImageUrl}/${widget.customer!.image ?? ''}',
                              height: 120, width: 150, fit: BoxFit.cover,
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                                  height: 120, width: 150, fit: BoxFit.cover),
                            ):Image.asset(Images.placeholder,height: 120,
                              width: 150, fit: BoxFit.cover,),
                          ),
                          Positioned(
                            bottom: 0, right: 0, top: 0, left: 0,
                            child: InkWell(
                              onTap: () => customerController.pickImage(false),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(25),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2, color: Colors.white),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ]));
                      }
                  ):
                  Align(alignment: Alignment.center, child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      child: supplierController.supplierImage != null ?  Image.file(File(supplierController.supplierImage!.path),
                        width: 150, height: 120, fit: BoxFit.cover,
                      ) :widget.supplier!=null? FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        image: '${Get.find<SplashController>().baseUrls!.supplierImageUrl}/${widget.supplier!.image ?? ''}',
                        height: 120, width: 150, fit: BoxFit.cover,
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                            height: 120, width: 150, fit: BoxFit.cover),
                      ):Image.asset(Images.placeholder,height: 120,
                        width: 150, fit: BoxFit.cover,),
                    ),
                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => supplierController.pickImage(false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ])),
                ]),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonWidget(
                isLoading: supplierController.isLoading || customerController.isLoading,
                buttonText:supplierUpdate || customerUpdate? 'update'.tr : 'save'.tr,
                onPressed: (){
                  String supplierName = supplierNameController.text.trim();
                  String supplierMobile = supplierPhoneNumber.text.trim();
                  String supplierEmailAddress = supplierEmail.text.trim();
                  String state = supplierState.text.trim();
                  String city = supplierCity.text.trim();
                  String zip = supplierZip.text.trim();
                  String address = supplierAddress.text.trim();
                  if(supplierName.isEmpty){
                    showCustomSnackBarHelper('name_required'.tr);
                  }else if(supplierMobile.isEmpty){
                    showCustomSnackBarHelper('mobile_required'.tr);
                  }else if(supplierEmailAddress.isEmpty){
                    showCustomSnackBarHelper('enter_email_address'.tr);
                  }
                  else if(EmailCheckerHelper.isNotValid(supplierEmailAddress)){
                    showCustomSnackBarHelper('enter_valid_email'.tr);
                  }else if(state.isEmpty){
                    showCustomSnackBarHelper('state_required'.tr);
                  }else if(city.isEmpty){
                    showCustomSnackBarHelper('city_required'.tr);
                  }else if(zip.isEmpty){
                    showCustomSnackBarHelper('zip_required'.tr);
                  }else if(address.isEmpty){
                    showCustomSnackBarHelper('address_required'.tr);
                  }
                  else{
                    Suppliers supplier = Suppliers(
                      id: supplierUpdate? widget.supplier!.id: null,
                      name: supplierName,
                      mobile : supplierMobile,
                      email : supplierEmailAddress,
                      state : state,
                      city : city,
                      zipCode : zip,
                      address : address,
                    );
                    Customers customer = Customers(
                      id: customerUpdate? widget.customer!.id : null,
                      name: supplierName,
                      mobile : supplierMobile,
                      email : supplierEmailAddress,
                      state : state,
                      city : city,
                      zipCode : zip,
                      address : address,
                    );

                    if(!widget.isCustomer){
                      supplierController.addSupplier(supplier,supplierUpdate);
                    }else{
                      Get.find<CustomerController>().addCustomer(customer, customerUpdate);
                    }

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
