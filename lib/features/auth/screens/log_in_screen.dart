import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/auth/controllers/auth_controller.dart';
import 'package:six_pos/helper/email_checker.dart';
import 'package:six_pos/helper/gradient_color_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/common/widgets/custom_dialog_widget.dart';
import 'package:six_pos/features/dashboard/screens/nav_bar_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _emailController.text = Get.find<AuthController>().getUserEmail();
    _passwordController.text = Get.find<AuthController>().getUserPassword();

    if(_passwordController.text != ''){
      Get.find<AuthController>().setRememberMe();
    }


  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => _onWillPop(context),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          decoration: BoxDecoration(
            gradient: GradientColorHelper.gradientColor(),
          ),
          child: Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: GetBuilder<AuthController>(builder: (authController) {
              return Column( mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
                Flexible(child: SingleChildScrollView(
                  child: Column(children: [
                    Image.asset(Images.splashLogo, width: 150),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Text('log_in'.tr, style: fontSizeBlack.copyWith(fontSize: Dimensions.fontSizeOverOverLarge)),
                    const SizedBox(height: 50),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(
                        fillColor: Colors.transparent,
                        hintText: 'enter_email_address'.tr,
                        controller: _emailController,
                        focusNode: _emailFocus,
                        nextFocus: _passwordFocus,
                        inputType: TextInputType.emailAddress,
                      ),
                      title: 'email'.tr,
                    ),

                    CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(
                        fillColor: Colors.transparent,
                        hintText: 'password'.tr,
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        inputAction: TextInputAction.done,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                      ),
                      title: 'password'.tr,
                    ),

                    Row(children: [
                      Expanded(
                        child: ListTile(
                          onTap: () => authController.toggleRememberMe(),
                          leading: Checkbox(
                            activeColor: Theme.of(context).primaryColor,
                            checkColor: Colors.white,
                            value: authController.isActiveRememberMe,
                            onChanged: (bool? isChecked) =>
                                authController.toggleRememberMe(),
                          ),
                          title: Text('remember_me'.tr),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          horizontalTitleGap: 0,
                        ),
                      ),
                    ]),
                  ],
                  ),
                ),
                ),

                CustomButtonWidget(
                  isLoading: authController.isLoading,
                  buttonText: 'log_in'.tr,
                  onPressed: () => _login(authController, _emailController, _passwordController, context),
                ),


                // demo login credential
                AppConstants.demo?
                const SizedBox(height: Dimensions.paddingSizeExtraLarge):const SizedBox(),
                AppConstants.demo?
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                  color: Theme.of(context).primaryColor.withOpacity(.125),
                ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                      Row(
                        children: [
                          Text('${'email'.tr} : ',style: fontSizeBold,),
                          const Text(' ${'admin@admin.com'}',style: fontSizeRegular,),
                        ],
                      ),
                      const SizedBox(height: Dimensions.fontSizeExtraSmall),
                      Row(
                        children: [
                          Text('${'password'.tr} : ', style: fontSizeBold),
                          const Text(' ${'12345678'}', style: fontSizeRegular),
                        ],
                      ),

                    ],),
                    InkWell(
                      onTap: (){
                        _emailController.text = "admin@admin.com";
                        _passwordController.text = "12345678";
                        showCustomSnackBarHelper('successfully_copied'.tr, isError: false);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                          color: Theme.of(context).primaryColor
                        ),
                        width: 50,height: 50,
                          child: Icon(Icons.copy,color: Theme.of(context).cardColor)),
                    ),
                  ],
                ),):const SizedBox(),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    createAccount('أنشاء حساب',context),
                    createAccount('الدعم الفنى',context),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    imageLogos(Images.logo,70.0),
                    imageLogos(Images.visionsaud,100.0),
                    imageLogos(Images.saudiIncome,100.0),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
              ]);
            }),
          ),
          ),
        ),
      ),
    );
  }

  void _login(
      AuthController authController,
      TextEditingController emailController,
      TextEditingController passController,
      BuildContext context) async {
    String password = passController.text.trim();
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      showCustomSnackBarHelper('enter_email_address'.tr);
    } else if (EmailCheckerHelper.isNotValid(email)) {
      showCustomSnackBarHelper('enter_valid_email'.tr);
    } else if (password.isEmpty) {
      showCustomSnackBarHelper('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBarHelper('password_should_be'.tr);
    } else {
      authController.login(emailAddress: email, password: password).then((status) async {
        if (status?.isSuccess ?? false) {
          if (authController.isActiveRememberMe) {
            authController.saveUserEmailAndPassword(emailAddress: email, password: password);
          } else {
            authController.clearUserEmailAndPassword();
          }
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const NavBarScreen()));
        }
      });



    }
  }
}

Future<bool> _onWillPop(BuildContext context) async {
  showAnimatedDialogHelper(context,
      CustomDialogWidget(
        icon: Icons.exit_to_app_rounded, title: 'exit'.tr,
        description: 'do_you_want_to_exit_the_app'.tr, onTapFalse:() => Navigator.of(context).pop(false),
        onTapTrue:() {
          SystemNavigator.pop();
        },
        onTapTrueText: 'yes'.tr, onTapFalseText: 'no'.tr,
      ),
      dismissible: false,
      isFlip: true);
  return true;
}

Widget createAccount(name,context)=>InkWell(
  onTap: (){},
  child: Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8)),
    width: MediaQuery.sizeOf(context).width/2.2,
    child: Center(child: Text(name,style: TextStyle(fontSize: 19,fontWeight: FontWeight.w500,color: Colors.white,),)),
  ),
);

Widget imageLogos(name,height)=>
    Image.asset(name,height: height,width: 100, );