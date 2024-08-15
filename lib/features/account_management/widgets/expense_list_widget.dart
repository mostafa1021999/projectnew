
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/account_management/controllers/expense_controller.dart';
import 'package:six_pos/features/user/widgets/account_shimmer_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/account_management/widgets/expense_info_view_widget.dart';



class ExpenseListWidget extends StatelessWidget {
  final bool isHome;
  final ScrollController scrollController;
  const ExpenseListWidget({Key? key, required this.scrollController, this.isHome = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ExpenseController>(
      builder: (expanseController) {

        return expanseController.expenseModel == null ? const AccountShimmerWidget(
        ) : (expanseController.expenseModel?.expensesList?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          onPaginate: (int? offset) async => await expanseController.getExpenseList(offset ?? 1),
          totalSize: expanseController.expenseModel?.totalSize,
          offset: expanseController.expenseModel?.offset,
          itemView: ListView.builder(
            shrinkWrap: true,
            itemCount: isHome && (expanseController.expenseModel?.expensesList?.length ?? 0) > 3 ? 3 : expanseController.expenseModel?.expensesList?.length,
            physics: isHome? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return ExpenseCardViewWidget(
                expense: expanseController.expenseModel?.expensesList?[index],
                index: index,
              );

            },
          ),
        ) : const NoDataWidget();
      },
    );
  }
}
