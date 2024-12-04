import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
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
import 'package:http/http.dart' as http;

import '../../common/controllers/account_controller.dart';
import '../../util/app_constants.dart';

class CreateUserScreen extends StatefulWidget {
  final bool isCustomer;
  final Suppliers? supplier;
  final Customers? customer;
  const CreateUserScreen({Key? key, this.isCustomer = false, this.supplier, this.customer}) : super(key: key);

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {

  TextEditingController supplierFirstNameController = TextEditingController();
  TextEditingController supplierLastNameController = TextEditingController();
  TextEditingController supplierPhoneNumber = TextEditingController();
  TextEditingController supplierEmail = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  File? _selectedFile;
  String? _fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'pdf'], // Specify allowed file types
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _submitForm(
      String supplierFirstName,
      String supplierLastName,
      String supplierMobile,
      String supplierEmailAddress,
      String passwordData,
      int? selectedCityId,
      File? selectedFile,
      AccountController accountController) async {

    if (selectedCityId == null || selectedFile == null) {
      showCustomSnackBarHelper('Please select an image and a city.');
      return;
    }
    accountController.setLoading(true);
    String cityName = cities.firstWhere((city) => city['id'] == selectedCityId)['name'];

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}${AppConstants.createAccountUri}',),
      // Replace with your API URL
    );

    request.fields['email'] = supplierEmailAddress;
    request.fields['f_name'] = supplierFirstName;
    request.fields['l_name'] = supplierLastName;
    request.fields['phone'] = supplierMobile;
    request.fields['city'] = cityName;
    request.fields['password'] = passwordData;

    request.files.add(
      http.MultipartFile(
        'commercial_register',
        selectedFile.readAsBytes().asStream(),
        selectedFile.lengthSync(),
        filename: selectedFile.path.split('/').last,
      ),
    );

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200||response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account created successfully!'),duration: Duration(seconds: 5),),
        );
        accountController.createNewAccount(request.fields);
        navigator!.pop();
      } else {
        var responseData = jsonDecode(response.body);
        String errorMessage = responseData['message'] ?? 'The name has already been taken.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$errorMessage')),
        );
        print(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }finally {
      accountController.setLoading(false);
    }
  }
  late bool customerUpdate, supplierUpdate;
  @override
  void initState() {
    super.initState();

    customerUpdate =  widget.customer != null;
    supplierUpdate = widget.supplier != null;
    if(customerUpdate){
      supplierFirstNameController.text = widget.customer?.name ?? '';
      supplierPhoneNumber.text = widget.customer?.mobile ?? '';
      supplierEmail.text = widget.customer?.email ?? '';
    }else if(supplierUpdate){
      supplierFirstNameController.text = widget.supplier?.name ?? '';
      supplierPhoneNumber.text = widget.supplier?.mobile ?? '';
      supplierEmail.text = widget.supplier?.email ?? '';
    }
  }
  final List<Map<String, dynamic>> cities = [
    {'id': 1, 'name': 'makkah'.tr},
    {'id': 2, 'name': 'riyadh'.tr},
    {'id': 3, 'name': 'jeddah'.tr},
    {'id': 4, 'name': 'dammam'.tr},
    {'id': 5, 'name': 'abha'.tr},
  ];
  int? selectedCityId;



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
                      controller: supplierFirstNameController,
                    ),
                    title: 'first_name'.tr,
                    requiredField: true,
                  ),
                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'enter_user_name'.tr,
                      controller: supplierLastNameController,
                    ),
                    title: 'last_name'.tr,
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
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15),
                    child: Align(
                      alignment:'city'.tr=='City'? Alignment.bottomLeft:Alignment.bottomRight,
                      child: RichText(
                        text: TextSpan(
                          text: 'city'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
                          children: <TextSpan>[
                            TextSpan(text: '  *', style: fontSizeBold.copyWith(color: Colors.red)) ,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0,right: 15),
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor,
                          border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                      child: DropdownButton<int>(
                        hint: Text('select'.tr),
                        value: selectedCityId,
                        items: cities.map((city) {
                              return DropdownMenuItem<int>(
                              value: city['id'],
                              child: Text(city['name']),
                              );
                              }).toList(),
                        onChanged: (int? value) {
                          setState(() {
                            selectedCityId = value!;
                          });
                        },
                        isExpanded: true, underline: const SizedBox(),),),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0,right: 40),
                    child: CustomButtonWidget(
                      isLoading: supplierController.isLoading || customerController.isLoading,
                      buttonText: 'commercial_register'.tr,
                      onPressed: _pickFile,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (_selectedFile != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0,right: 15),
                      child: Text('$_selectedFile'),
                    ),
                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'enter_password'.tr,
                      controller: password,
                      inputType: TextInputType.visiblePassword,
                      inputAction: TextInputAction.done,
                      isPassword: true,
                    ),
                    title: 'password'.tr,
                    requiredField: true,
                  ),
                  CustomFieldWithTitleWidget(
                    customTextField: CustomTextFieldWidget(hintText: 'enter_password'.tr,
                      controller: confirmPassword,
                      inputType: TextInputType.visiblePassword,
                      isPassword: true,
                    ),
                    title: 'confirm_password'.tr,
                    requiredField: true,
                  ),
                ]),
              ),
            ),


            GetBuilder<AccountController>(builder: (accountController)=> Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButtonWidget(
                  isLoading:  accountController.isLoading,
                  buttonText: 'create_account'.tr,
                  onPressed: (){
                    String supplierFirstName = supplierFirstNameController.text.trim();
                    String supplierLastName = supplierLastNameController.text.trim();
                    String supplierMobile = supplierPhoneNumber.text.trim();
                    String supplierEmailAddress = supplierEmail.text.trim();
                    String passwordData = password.text.trim();
                    String confirmPasswordData = confirmPassword.text.trim();
                    if(supplierFirstName.isEmpty){
                      showCustomSnackBarHelper('first_name_required'.tr);
                    }else if(supplierLastName.isEmpty){
                      showCustomSnackBarHelper('last_name_required'.tr);
                    }else if(supplierMobile.isEmpty){
                      showCustomSnackBarHelper('mobile_required'.tr);
                    }else if(supplierEmailAddress.isEmpty){
                      showCustomSnackBarHelper('enter_email_address'.tr);
                    }
                    else if(EmailCheckerHelper.isNotValid(supplierEmailAddress)){
                      showCustomSnackBarHelper('enter_valid_email'.tr);
                    }else if(passwordData.isEmpty||passwordData.length<8){
                      showCustomSnackBarHelper('enter_8_digit_password'.tr);
                    }else if(confirmPasswordData!=passwordData){
                      showCustomSnackBarHelper('password_not_match'.tr);
                    }else{
                      _submitForm(
                        supplierFirstName,
                        supplierLastName,
                        supplierMobile,
                        supplierEmailAddress,
                        passwordData,
                        selectedCityId,
                        _selectedFile,
                        accountController,
                      );
                    }
                  },
                ),
              ),
            ),
          ]);
        });
      }),
    );
  }
}
