import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/features/dashboard/controllers/menu_controller.dart';
import 'package:six_pos/features/dashboard/domain/tab_type_enum.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_on_tap_widget.dart';
import 'package:six_pos/features/dashboard/screens/nav_bar_screen.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackButtonExist;
  const CustomAppBarWidget({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BottomManuController menuController = Get.find<BottomManuController>();

    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      titleSpacing: 0, elevation: 5,
      leadingWidth: isBackButtonExist ? 50 : 120,
      leading: isBackButtonExist ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
        child: CustomOnTapWidget(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_sharp, color: Theme.of(context).primaryColor, size: 25),) ,
      ) : Padding(
        padding: const EdgeInsets.only(left: Dimensions.fontSizeExtraSmall),
        child: InkWell(
            onTap: ()=>  menuController.onChangeMenu(type: NavbarType.dashboard),
            child: Image.asset(Images.logoWithName, width: 120, height: 30)),
      ),
      title:const Text(''),
      actions: [
         GetBuilder<ProfileController>(
          builder: (profileController) {
            return (profileController.modulePermission?.pos ?? false) ? GetBuilder<CartController>(
              builder: (cartController) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    onPressed: () {
                      Get.to(const NavBarScreen());
                      menuController.onChangeMenu(type: NavbarType.pos);
                    },
                    icon: Stack(clipBehavior: Clip.none, children: [
                      Image.asset(
                        Images.cart,
                        height: Dimensions.iconSizeDefault,
                        width: Dimensions.iconSizeDefault,
                        color: Theme.of(context).primaryColor,
                      ),
                      Positioned(top: -4, right: -4,
                        child: CircleAvatar(radius: 7, backgroundColor: Theme.of(context).secondaryHeaderColor,
                          child: Text('${cartController.customerCartList.isNotEmpty
                              ? cartController.customerCartList[cartController.customerIndex].cart!.length
                              : 0 }',
                              style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor,
                              fontSize: Dimensions.fontSizeSmall)), ),
                      ),
                    ],),
                  ),
                );
              }
            ) : const SizedBox();
          }
        ),

        Builder( builder: (context) {
          return IconButton( onPressed:()=> Scaffold.of(context).openEndDrawer(),
            icon: Icon(Icons.menu_outlined, color: Theme.of(context).primaryColor),
          );
        }),
      ],
    );
  }

  @override
  Size get preferredSize => Size(Dimensions.webMaxWidth, GetPlatform.isDesktop ? 70 : 50);
}