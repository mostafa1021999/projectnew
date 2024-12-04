import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/widgets/custom_button_widget.dart';
import '../../../common/widgets/custom_field_with_title_widget.dart';
import '../../../common/widgets/custom_text_field_widget.dart';
import '../../../helper/show_custom_snackbar_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../dashboard/screens/nav_bar_screen.dart';
import '../controllers/auth_controller.dart';

class EnterNewPassword extends StatelessWidget {
  EnterNewPassword({Key? key ,required this.email}) : super(key: key);
  var email;
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) { return Scaffold(
        body: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () async {
                  await launchUrl(Uri.parse('https://erpstax.com/'));
                },
                child: Image.asset(Images.splashLogo, width: 150)),
            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
            Text('enter_password'.tr, style: fontSizeBlack.copyWith(
                fontSize: Dimensions.fontSizeOverOverLarge)),
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
                inputAction: TextInputAction.done,
                inputType: TextInputType.visiblePassword,
                isPassword: true,
              ),
              title: 'confirm_password'.tr,
              requiredField: true,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15),
              child: CustomButtonWidget(
                isLoading: authController.isLoading,
                buttonText: 'password_change'.tr,
                onPressed:(){
                  if(password.text.isEmpty||password.text.length<8){
                    showCustomSnackBarHelper('enter_8_digit_password'.tr);
                  }else if(confirmPassword.text.trim()!=password.text.trim()){
                    showCustomSnackBarHelper('password_not_match'.tr);
                  }else {
                    authController.changePassword(emailAddress: email,password: password.text.trim(),confirm:confirmPassword.text.trim() ).then((status) async {
                      if (status?.isSuccess ?? false) {
                        authController.login(emailAddress: email, password: password.text.trim()).then((status) async {
                          if (status?.isSuccess ?? false) {
                            if (authController.isActiveRememberMe) {
                              authController.saveUserEmailAndPassword(emailAddress: email, password:  password.text.trim());
                            } else {
                              authController.clearUserEmailAndPassword();
                            }
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const NavBarScreen()));
                          }
                        });
                      }else{

                      }
                    });
                  }
                },
              ),
            ),
        ],),));});
  }
}
