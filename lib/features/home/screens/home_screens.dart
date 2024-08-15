import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/account_controller.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/features/dashboard/controllers/menu_controller.dart';
import 'package:six_pos/features/dashboard/domain/tab_type_enum.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/home/widgets/transaction_chart_widget.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/features/home/widgets/title_row_widget.dart';
import 'package:six_pos/features/account_management/screens/account_list_screen.dart';
import 'package:six_pos/features/account_management/widgets/account_list_widget.dart';
import 'package:six_pos/features/home/widgets/statistics_widget.dart';
import 'package:six_pos/features/product/widgets/limited_stock_product_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double? maxYExpense = 0, maxYIncome = 0;
  double intervalRateExpense = 0, intervalRateIncome = 0;
  double spaceRateExpense = 0, spaceRateIncome = 0;



  @override
  void initState() {
    super.initState();
  }


  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(.03),
      resizeToAvoidBottomInset: false,
      endDrawer: const CustomDrawerWidget(),

      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
          },
          child: GetBuilder<ProfileController>(builder: (profileController){
            return profileController.profileModel == null ? const CustomLoaderWidget() : (profileController.modulePermission?.dashboard ?? false) ?   CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(children: [

                    const StatisticsWidget(),

                    GetBuilder<AccountController>(
                        builder: (chartController) {
                          if(chartController.yearWiseExpenseList.isNotEmpty){


                            maxYExpense =  chartController.yearWiseExpenseList[chartController.yearWiseExpenseList.length-1].totalAmount;
                            intervalRateExpense = maxYExpense!.ceil()/5;

                            maxYIncome =  chartController.yearWiseIncomeList[chartController.yearWiseIncomeList.length-1].totalAmount;
                            intervalRateIncome = maxYIncome!.ceil()/5;

                          }

                          return Padding(padding: const EdgeInsets.all(10),
                            child: TransactionChartWidget(maxYExpense: intervalRateExpense,
                              maxYIncome: intervalRateIncome,
                            ),
                          );
                        }
                    ),

                    if(profileController.modulePermission?.account ?? false) GetBuilder<AccountController>(
                        builder: (account) {
                          return account.accountModel == null ? const CustomLoaderWidget() :  (account.accountModel?.accountList?.isNotEmpty ?? false)? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
                                        Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault),
                                    child: Row(
                                      children: [
                                        SizedBox(width: Dimensions.iconSizeSmall,child: Image.asset(Images.myAccount)),
                                        const SizedBox(width: Dimensions.paddingSizeSmall),
                                        Expanded(child: TitleRowWidget(title: 'my_account'.tr,onTap: () async {
                                          await Get.to(const AccountListScreen(fromAccount: true));

                                          account.getAccountList(1);

                                        },)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, bottom: Dimensions.paddingSizeSmall,
                                  right: Dimensions.paddingSizeDefault,
                                ),
                                child: Row(children: [
                                  const Text('#'),
                                  const SizedBox(width: Dimensions.paddingSizeLarge),
                                  Expanded(flex:8,
                                      child: Text('account'.tr,
                                        style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: ColorResources.getTitleColor()),)),
                                  Text('balance'.tr,
                                    style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: ColorResources.getTitleColor()),),
                                ],),
                              ),
                              Container(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor
                                  ), child: AccountListWidget(scrollController: _scrollController, isHome: true)),
                            ],
                          ):const SizedBox();
                        }
                    ),

                    if(profileController.modulePermission?.limitedStock ?? false)
                      GetBuilder<ProductController>(
                          builder: (stockOutProduct) {
                            return (stockOutProduct.limitedStockProductModel?.stockLimitedProducts?.isNotEmpty ?? false) ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,
                                          Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault),
                                      child: Row(
                                        children: [
                                          SizedBox(width: Dimensions.iconSizeSmall,child: Image.asset(Images.limitedStock)),
                                          const SizedBox(width: Dimensions.paddingSizeSmall),
                                          Expanded(child: TitleRowWidget(title: 'limited_stocks'.tr,onTap: (){
                                            Get.find<BottomManuController>().onChangeMenu(type: NavbarType.limitedStock);
                                          },)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault,bottom: Dimensions.paddingSizeSmall,
                                      right: Dimensions.paddingSizeDefault),
                                  child: Row(children: [
                                    const Text('#'),
                                    const SizedBox(width: Dimensions.paddingSizeLarge),
                                    Expanded(flex:9,
                                        child: Text('product_name'.tr,
                                          style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: ColorResources.getTitleColor()),)),
                                    Text('qty'.tr,
                                      style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: ColorResources.getTitleColor()),),
                                  ],),
                                ),
                                Container(padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeExtraLarge),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor
                                    ),  child: LimitedStockProductListWidget(scrollController: _scrollController, isHome: true)),
                              ],
                            ): const SizedBox();
                          }
                      ),

                  ]),
                )
              ],
            ) : Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomAssetImageWidget(
                  Images.accessDeny,
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  height: MediaQuery.sizeOf(context).width * 0.7,
                ),
                const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                Text('you_do_not_have_access_to_this_contact'.tr, style: fontSizeMedium.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeLarge,
                )),
              ],

            ));
          }),
        ),
      ),
    );
  }
}


class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  SliverDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != 70 || oldDelegate.minExtent != 70 || child != oldDelegate.child;
  }
}



