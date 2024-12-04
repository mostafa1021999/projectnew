import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:six_pos/features/auth/forget%20password/check%20code.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common/widgets/custom_button_widget.dart';
import '../../../common/widgets/custom_field_with_title_widget.dart';
import '../../../common/widgets/custom_text_field_widget.dart';
import '../../../helper/show_custom_snackbar_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../controllers/auth_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      TextEditingController supplierEmail = TextEditingController();
      return Scaffold(
          body: Center(
            child: GetBuilder<AuthController>(builder: (authController) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () async {
                        await launchUrl(Uri.parse('https://erpstax.com/'));
                      },
                      child: Image.asset(Images.splashLogo, width: 150)),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Text('get_password'.tr, style: fontSizeBlack.copyWith(
                      fontSize: Dimensions.fontSizeOverOverLarge)),
                  CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(
                        hintText: 'admin@admin.com'.tr,
                        controller: supplierEmail,),
                      title: 'email'.tr,
                      requiredField: false
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: CustomButtonWidget(
                      isLoading: authController.isLoading,
                      buttonText: 'send_code'.tr,
                      onPressed:(){
                        if (supplierEmail.text.isEmpty) {
                          showCustomSnackBarHelper('enter_email_address'.tr);
                        }else {
                          authController.sendCodeEmail(emailAddress: supplierEmail.text.trim()).then((status) async {
                            if (status?.isSuccess ?? false) {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => CheckCode(email: supplierEmail.text.trim(),)));
                            }else{

                            }
                          });
                        }
                      },
                    ),
                  ),
                ],);
            },),
          ));
    });
  }

}

