import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pinput/pinput.dart';
import 'package:six_pos/features/auth/forget%20password/enter%20new%20password.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/widgets/custom_button_widget.dart';
import '../../../helper/show_custom_snackbar_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../controllers/auth_controller.dart';

class CheckCode extends StatelessWidget {
  CheckCode({Key? key,required this.email}) : super(key: key);
  var email;
  final TextEditingController _otpController=TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: GetBuilder<AuthController>(builder: (authController) { return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            onTap: () async {
              await launchUrl(Uri.parse('https://erpstax.com/'));
            },
            child: Image.asset(Images.splashLogo, width: 150)),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
        Text('enter_code'.tr, style: fontSizeBlack.copyWith(
            fontSize: Dimensions.fontSizeOverOverLarge)),
        SizedBox(height: 20,),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: Pinput(
              controller: _otpController,
              enabled: authController.isLoading?false : true,
              focusNode: _pinFocusNode,
              autofocus:true,
              defaultPinTheme:PinTheme(
                width: 56,
                height: 56,
                textStyle: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).primaryColor,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.transparent),
                ),
              ),
              onSubmitted: (code) {
                authController.verifyCodeEmail(emailAddress: email,otp: _otpController.text.trim()).then((status) async {
                  if (status?.isSuccess ?? false) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => EnterNewPassword(email: email,)));
                  }else{

                  }
                });
              },
              onChanged: (code) {
                if(code.length==4){
                  authController.verifyCodeEmail(emailAddress: email,otp: _otpController.text.trim()).then((status) async {
                    if (status?.isSuccess ?? false) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => EnterNewPassword(email: email,)));
                    }else{

                    }
                  });
                }
              },
              length: 4,
            ),
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50),
          child: CustomButtonWidget(
            isLoading: authController.isLoading,
            buttonText: 'verify'.tr,
            onPressed:(){
              if (_otpController.text.isEmpty) {
                showCustomSnackBarHelper('enter_email_address'.tr);
              }else {
                authController.verifyCodeEmail(emailAddress: email,otp: _otpController.text.trim()).then((status) async {
                  if (status?.isSuccess ?? false) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => EnterNewPassword(email: email,)));
                  }else{

                  }
                });
              }
            },
          ),
        ),
      ],
    );},),));
  }
}
