import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/employe_role/controllers/employee_controller.dart';
import 'package:six_pos/features/employe_role/controllers/employee_role_controller.dart';
import 'package:six_pos/features/employe_role/domain/models/employee_model.dart';
import 'package:six_pos/features/employe_role/domain/models/role_model.dart';
import 'package:six_pos/helper/email_checker.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class AddEmployeeScreen extends StatefulWidget {
  final Employee? employee;
  const AddEmployeeScreen({Key? key, this.employee}) : super(key: key);


  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _phoneTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _lastNameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();


  @override
  void initState() {

    _initLoad();
    super.initState();
  }

  void _initLoad() {
    final RoleController roleController = Get.find<RoleController>();
    final EmployeeController employeeController = Get.find<EmployeeController>();

    employeeController.onChangeRoleId(null, isUpdate: false);
    roleController.getRoleList(1);

    if(widget.employee != null) {
      _nameTextController.text = widget.employee?.fName ?? '';
      _lastNameTextController.text = widget.employee?.lName ?? '';
      _phoneTextController.text = widget.employee?.phone ?? '';
      _emailTextController.text = widget.employee?.email ?? '';

      employeeController.onChangeRoleId(widget.employee?.roleId, isUpdate: false);
    }
    employeeController.pickImage(true, isUpdate: false);





  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer: const CustomDrawerWidget(),

      appBar: const CustomAppBarWidget(isBackButtonExist: true),

      body: GetBuilder<EmployeeController>(
          builder: (employeeController) {
            return Column(children: [
              CustomHeaderWidget(
                title: widget.employee == null ? 'add_new_employee'.tr : 'update_employee'.tr,
                headerImage: Images.employeeList,
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(
                        hintText:   'enter_customer_name'.tr,
                        controller: _nameTextController,
                        focusNode: _nameFocusNode,
                        nextFocus: _lastNameFocusNode,
                      ),
                      title:  'first_name'.tr,
                      requiredField: true,
                    ),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(
                        hintText: 'enter_customer_name'.tr,
                        controller: _lastNameTextController,
                        focusNode: _lastNameFocusNode,
                        nextFocus: _phoneFocusNode,
                      ),
                      title:  'last_name'.tr,
                      requiredField: false,
                    ),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'enter_phone_number'.tr,
                        controller: _phoneTextController,
                        inputType: TextInputType.phone,
                        focusNode: _phoneFocusNode,
                        nextFocus: _emailFocusNode,
                      ),
                      title: 'phone_number'.tr,
                      requiredField: true,
                    ),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(
                        hintText: 'enter_email_address'.tr,
                        controller: _emailTextController,
                        focusNode: _emailFocusNode,
                        nextFocus: _passwordFocusNode,
                        inputType: TextInputType.emailAddress,
                      ),
                      title: 'email'.tr,
                      requiredField: true,
                    ),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(
                        isPassword: true,
                        hintText: 'enter_password'.tr,
                        controller: _passwordTextController,
                        focusNode: _passwordFocusNode,
                        nextFocus: _confirmPasswordFocusNode,
                      ),
                      title: 'password'.tr,
                      requiredField: true,
                    ),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(
                        isPassword: true,
                        hintText: 'confirm_password'.tr,
                        controller: _confirmPasswordTextController,
                      ),
                      title: 'confirm_password'.tr,
                      requiredField: true,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
                        Row(
                          children: [
                            Text('role'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor)),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Text('*', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor)),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        GetBuilder<RoleController>(
                          builder: (roleController) {
                            return Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                  border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                              child: DropdownButton<int>(
                                hint: Text('select'.tr),
                                value: employeeController.selectRoleId,
                                items: roleController.roleModel?.roleList?.map((RoleItemModel? value) {
                                  return DropdownMenuItem<int>(
                                      value: value?.id,
                                      child: Text('${value?.name}'));
                                }).toList(),
                                onChanged: (int? value) {
                                  employeeController.onChangeRoleId(value);
                                },
                                isExpanded: true,
                                underline: const SizedBox(),
                              ),
                            );
                          }
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                      ]),
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

                    Align(alignment: Alignment.center, child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                        child: employeeController.employeeImage != null ?  Image.file(
                          File(employeeController.employeeImage!.path),
                          width: 150, height: 120, fit: BoxFit.cover,
                        ) : CustomImageWidget(
                          image: widget.employee?.imageFullpath ?? '',
                          height: 120, width: 150, fit: BoxFit.cover,
                        ),
                      ),

                      Positioned(
                        bottom: 0, right: 0, top: 0, left: 0,
                        child: InkWell(
                          onTap: () => employeeController.pickImage(false),
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
                  isLoading: employeeController.isLoading,
                  buttonText: 'save'.tr,
                  onPressed: (){
                    _onSubmit();
                  },
                ),
              ),
            ]);
          }
      ),
    );
  }

  void _onSubmit() {
    final EmployeeController employeeController = Get.find<EmployeeController>();

    String? firstName = _nameTextController.text.trim();
    String? lastName = _lastNameTextController.text.trim();
    String? phone = _phoneTextController.text.trim();
    String? email = _emailTextController.text.trim();
    String? password = _passwordTextController.text.trim();
    String? confirmPassword = _confirmPasswordTextController.text.trim();


    if(firstName.isEmpty){
      showCustomSnackBarHelper('name_required'.tr);

    }else if(phone.isEmpty){
      showCustomSnackBarHelper('enter_phone_number'.tr);

    }else if(employeeController.selectRoleId == null){
      showCustomSnackBarHelper('select_role'.tr);

    }else if(email.isEmpty){
      showCustomSnackBarHelper('enter_email_address'.tr);

    }else if(EmailCheckerHelper.isNotValid(email)){
      showCustomSnackBarHelper('enter_a_valid_mail'.tr);

    }else if(email.isEmpty){
      showCustomSnackBarHelper('email_required'.tr);

    }else if((widget.employee == null || password.isNotEmpty) && password.length < 8 ){
      showCustomSnackBarHelper('enter_8_digit_password'.tr);

    }else if((widget.employee == null || password.isNotEmpty) && confirmPassword.length < 8){
      showCustomSnackBarHelper('confirm_8_digit_password'.tr);

    }else if((widget.employee == null || password.isNotEmpty) && confirmPassword != password){
      showCustomSnackBarHelper('password_not_match'.tr);

    }else {
      Employee employee = Employee(
        fName: firstName,
        lName: lastName,
        phone: phone,
        email: email,
        password: password,
        roleId: employeeController.selectRoleId,
        id: widget.employee?.id,
      );

      employeeController.addEmployee(employee, widget.employee != null);


    }


  }

}
