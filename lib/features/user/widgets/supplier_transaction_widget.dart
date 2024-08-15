import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/features/user/domain/models/supplier_model.dart';
import 'package:six_pos/features/user/widgets/account_shimmer_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/account_management/widgets/transaction_list_card_widget.dart';


class SupplierTransactionListWidget extends StatelessWidget {
  final Suppliers? supplier;
  final ScrollController scrollController;
  const SupplierTransactionListWidget({Key? key, required this.scrollController, this.supplier}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<SupplierController>(
      builder: (supplierController) {

        if(supplierController.transactionModel == null) return const AccountShimmerWidget();

        return (supplierController.transactionModel?.transferList?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          onPaginate: (int? offset) async {
            if(supplierController.startDate != null  && supplierController.endDate != null) {
              await supplierController.getSupplierTransactionFilterList(
                offset ?? 1, supplier?.id,
                supplierController.startDate!,
                supplierController.endDate!,
              );

            }else {
              await supplierController.getSupplierTransactionList(offset ?? 1, supplier?.id);
            }
          },
          totalSize: supplierController.transactionModel?.totalSize,
          offset: supplierController.transactionModel?.offset,
          limit: supplierController.transactionModel?.limit,
          itemView: ListView.builder(
            shrinkWrap: true,
            itemCount: supplierController.transactionModel?.transferList?.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return TransactionCardViewWidget(
                transfer: supplierController.transactionModel?.transferList?[index],
              );
            },
          ),
        ) : const NoDataWidget();

      },
    );
  }
}
