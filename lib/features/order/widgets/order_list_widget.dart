import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/order/widgets/order_card_widget.dart';


class OrderListWidget extends StatelessWidget {
  final ScrollController scrollController;
  const OrderListWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<OrderController>(
      builder: (orderController) {
        return orderController.orderModel == null ? const CustomLoaderWidget(
        ) : (orderController.orderModel?.orderList?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          onPaginate: (int? offset) async => await orderController.getOrderList(offset ?? 1),
          totalSize: orderController.orderModel?.totalSize,
          offset: orderController.orderModel?.offset,
          itemView: ListView.builder(
            shrinkWrap: true,
            itemCount: orderController.orderModel?.orderList?.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return OrderCardWidget(order: orderController.orderModel?.orderList?[index]);

            },
          ),
        ) : const NoDataWidget();
      },
    );
  }
}
