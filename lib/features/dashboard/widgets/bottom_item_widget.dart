import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/dashboard/controllers/menu_controller.dart';
import 'package:six_pos/util/dimensions.dart';

class BottomItemWidget extends StatelessWidget {
  final String icon;
  final String name;
  final int? selectIndex;
  final VoidCallback? tap;

  const BottomItemWidget({
    Key? key, required this.icon, required this.name, this.selectIndex, this.tap,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final BottomManuController bottomMenuController = Get.find<BottomManuController>();

    return InkWell(
      onTap: tap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(height: Dimensions.navbarIconSize, width: Dimensions.navbarIconSize,
          child: Image.asset(icon, fit: BoxFit.contain,
            color: Get.find<BottomManuController>().currentTabIndex == selectIndex
              ? Theme.of(context).primaryColor
                : Theme.of(context).hintColor.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 6.0),

        Text(name, style: TextStyle(
          color: bottomMenuController.currentTabIndex == selectIndex ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withOpacity(0.8),
          fontSize: Dimensions.navbarFontSize, fontWeight: FontWeight.w400,
        ))
      ]),
    );
  }
}
