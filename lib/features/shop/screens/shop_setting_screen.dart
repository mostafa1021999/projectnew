import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/features/shop/widgets/shop_info_field_widget.dart';

class ShopSettingScreen extends StatefulWidget {
  const ShopSettingScreen({Key? key}) : super(key: key);

  @override
  State<ShopSettingScreen> createState() => _ShopSettingScreenState();
}

class _ShopSettingScreenState extends State<ShopSettingScreen> with TickerProviderStateMixin{
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
    Get.find<ProfileController>().getTimeZoneList();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),

      appBar: const CustomAppBarWidget(),

      body: GetBuilder<SplashController>(
        builder: (shopController) {
          return Column( children: [
            CustomHeaderWidget(title: 'shop_settings'.tr, headerImage: Images.shopIcon),
            Center(
              child: Container(
                width: 1170,
                color: Theme.of(context).cardColor,
                child: TabBar(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge),
                  controller: _tabController,
                  labelColor: Theme.of(context).secondaryHeaderColor,
                  unselectedLabelColor: Theme.of(context).primaryColor,
                  indicatorColor: Theme.of(context).secondaryHeaderColor,
                  indicatorWeight: 3,
                  unselectedLabelStyle: fontSizeRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w400,
                  ),
                  labelStyle: fontSizeRegular.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w700,
                  ),
                  tabs: [
                    Tab(text: 'general_info'.tr),
                    Tab(text: 'business_info'.tr),
                  ],
                ),
              ),
            ),

            Expanded(child: TabBarView(
              controller: _tabController,
              children: [
                ShopInfoFieldWidget(configModel: shopController.configModel,),
                ShopInfoFieldWidget(isBusinessInfo: true, configModel: shopController.configModel,),
              ],
            )),
          ]);
        }
      ),
    );
  }
}

