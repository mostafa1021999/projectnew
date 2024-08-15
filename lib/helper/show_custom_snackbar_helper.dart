import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBarHelper(String? message, {bool isError = true, bool isToaster = false}) {
  if(message != null && message.isNotEmpty) {
    if(isToaster){
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: isError ? Colors.red : Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
      );
    }else{

      ScaffoldMessenger.of(Get.context!).clearSnackBars();
      ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(key: UniqueKey(), content: Text(message),
        duration: const Duration(milliseconds: 4000),
        behavior: SnackBarBehavior.floating ,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: isError ? Colors.red : Colors.green,
      )
      );

      // Get.showSnackbar(GetSnackBar(
      //   backgroundColor: isError ? Colors.red : Colors.green,
      //   message: message,
      //   maxWidth: Dimensions.webMaxWidth,
      //   duration: const Duration(seconds: 3),
      //   snackStyle: SnackStyle.FLOATING,
      //   margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      //   borderRadius: Dimensions.radiusSmall,
      //   isDismissible: true,
      //   dismissDirection: DismissDirection.horizontal,
      // ));
    }

  }
}