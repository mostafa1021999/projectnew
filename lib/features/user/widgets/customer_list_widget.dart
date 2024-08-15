
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/user/controllers/customer_controller.dart';
import 'package:six_pos/features/user/widgets/account_shimmer_widget.dart';
import 'package:six_pos/features/user/widgets/customer_card_view_widget.dart';


class CustomerListWidget extends StatelessWidget {
  final ScrollController scrollController;
  const CustomerListWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<CustomerController>(
      builder: (customerController) {

        if(customerController.customerModel == null) {
          return const AccountShimmerWidget();
        }

        return (customerController.customerModel?.customerList?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          onPaginate: (int? offset) => customerController.getCustomerList(offset ?? 0),
          totalSize: customerController.customerModel?.totalSize,
          offset: customerController.customerModel?.offset,
          itemView: ListView.builder(
            shrinkWrap: true,
            itemCount: customerController.customerModel?.customerList?.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return CustomerCardViewWidget(customer: customerController.customerModel?.customerList?[index]);

            },
          ) ,
        ) : const NoDataWidget();
      },
    );
  }
}
