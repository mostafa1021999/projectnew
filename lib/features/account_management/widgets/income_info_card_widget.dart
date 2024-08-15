import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/account_management/domain/models/income_model.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_divider.dart';

class IncomeInfoCardWidget extends StatelessWidget {
  final Incomes? income;
  final int? index;
  const IncomeInfoCardWidget({Key? key, this.index, this.income}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),

        Container(color: Theme.of(context).cardColor, child: Column(children: [
          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: Text('${index! + 1}.', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor),),
            title: Column( crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text('Account type: ${income!.account != null? income!.account!.account: ''}', style: fontSizeMedium.copyWith(color: Theme.of(context).primaryColor),),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Debit: ', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

                Text('- ${income!.debit == 1? PriceConverterHelper.priceWithSymbol(income!.amount!): 0}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

              ],),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Credit: ', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

                Text(' ${income!.credit == 1? PriceConverterHelper.priceWithSymbol(income!.amount!): 0 }', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),

              ],),

            ]),

          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
            child: CustomDividerWidget(color: Theme.of(context).hintColor),
          ),

          ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const SizedBox(),
            title: Text('Balance', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
            trailing: Text(' ${PriceConverterHelper.priceWithSymbol(income!.balance!)}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
            child: Row(children: [
              Text('${'description'.tr} : ', style: fontSizeRegular.copyWith(color: ColorResources.getTextColor())),

              Text('- ${income!.description}', style: fontSizeRegular.copyWith(color:  Theme.of(context).hintColor)),

            ],),
          ),
        ],),),

        Container(height: 5, color: Theme.of(context).primaryColor.withOpacity(0.06)),
      ],
    );
  }
}
