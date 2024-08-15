import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';


class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor
      ),
      child: GetBuilder<ProfileController>(
        builder: (profileController) {

          double revenue = 0;
          List<String> itemsTitle =[];
          List<String> itemsAmount =[];
          List<String> bg =[];

          if(profileController.revenueModel != null){
            revenue = profileController.revenueModel!.totalIncome! -
                profileController.revenueModel!.totalExpense!;

             itemsTitle = ['total_revenue'.tr, 'total_income'.tr, 'total_expense'.tr, 'account_receivable'.tr, 'account_payable'.tr];
             itemsAmount = [(revenue.toString()), '${profileController.revenueModel!.totalIncome}',
               '${profileController.revenueModel!.totalExpense}', '${profileController.revenueModel!.totalReceivable}',
               '${profileController.revenueModel!.totalPayable}'];
             bg = ['0xFF286FC6', '0xFF5ABD88', '0xFFD0517F', '0xFF2BA361', '0xFFFF6D6D'];

          }

          return Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center,children: [
                SizedBox(width: Dimensions.iconSizeDefault,height: Dimensions.iconSizeDefault,
                  child: Image.asset(Images.revenue),),
                const SizedBox(width: Dimensions.paddingSizeSmall,),
                Text('revenue_statistics'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),

                const Expanded(child: SizedBox(width: Dimensions.paddingSizeExtraLarge,)),
                Container(
                  height: 50,width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

                  ),
                  child: DropdownButton<String>(
                    value: profileController.revenueFilterTypeIndex == 0 ? 'overall' : profileController.revenueFilterTypeIndex == 1 ? 'today' : 'month',
                    items: <String>['overall', 'today', 'month' ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value.tr, style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeDefault),),
                      );
                    }).toList(),
                    onChanged: (value) {
                      profileController.setRevenueFilterName(value, true);
                      profileController.setRevenueFilterType(value == 'overall' ? 0 : value == 'today' ? 1 : 2, true);

                    },
                    isExpanded: true,
                    underline: const SizedBox(),
                  ),
                ),


              ],),
              const SizedBox(height: Dimensions.paddingSizeSmall,),
              profileController.revenueModel != null?
              SizedBox(height: Dimensions.revenueCard,
                child: ListView.builder(
                  itemCount: 5,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeCard),
                        width: Dimensions.dashboardCardWidth,height: Dimensions.revenueCard,
                        decoration: BoxDecoration(
                          color: Color(int.parse(bg[index])),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)
                        ),
                        child: Stack(
                          children: [
                            Positioned(bottom: Dimensions.paddingSizeLarge,left: Dimensions.paddingSizeLarge,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                Text(PriceConverterHelper.priceWithSymbol(double.parse(itemsAmount[index])),maxLines: 2,overflow: TextOverflow.ellipsis, style: fontSizeBold.copyWith(color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.fontSizeExtraLarge),),
                                const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                                Text(itemsTitle[index],style: fontSizeRegular.copyWith(color: Theme.of(context).cardColor,
                                    fontSize: Dimensions.fontSizeDefault)),
                      ],),
                            ),
                            Positioned(top: Dimensions.paddingSizeSmall,
                              right: Dimensions.paddingSizeSmall,
                              child: SizedBox(width: Dimensions.iconSizeDefault,height: Dimensions.iconSizeDefault,
                                  child: Image.asset(Images.dollar)),
                            ),
                          ],
                        ),),
                    );

                }),
              ):const SizedBox(),
            ],
          );
        }
      ),
    );
  }
}
