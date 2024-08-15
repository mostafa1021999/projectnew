import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';


class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Images.noDataFound, width: 150, height: 150),
          Text('no_data_found'.tr,
            style: fontSizeBold.copyWith(color: Theme.of(context).primaryColor, fontSize: MediaQuery.of(context).size.height*0.023),
            textAlign: TextAlign.center,
          ),

        ]),
      ),
    );
  }
}
