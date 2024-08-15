
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/features/account_management/domain/models/transaction_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/features/user/widgets/account_shimmer_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/account_management/widgets/transaction_list_card_widget.dart';



class TransactionListWidget extends StatelessWidget {
  final bool isHome;

  const TransactionListWidget({Key? key, this.isHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<TransactionController>(
      builder: (transactionController) {
        List<Transfers>? transactionList;
        transactionList = transactionController.transactionList;

        return transactionController.filterClick ? const AccountShimmerWidget() : Column(children: [
          transactionList == null ? const AccountShimmerWidget() :   transactionList.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
              itemCount: isHome && transactionList.length> 3 ? 3: transactionList.length,
              physics: isHome? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return TransactionCardViewWidget(transfer: transactionList![index], index: index);

              }) : const NoDataWidget(),

          transactionController.isLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox.shrink(),

        ]);
      },
    );
  }
}
