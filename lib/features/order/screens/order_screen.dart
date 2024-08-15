import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/user/controllers/customer_controller.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/features/order/widgets/order_list_widget.dart';
import 'package:six_pos/features/order/widgets/customer_wise_order_list_widget.dart';

class OrderScreen extends StatefulWidget {
  final bool fromNavBar;
  final bool isCustomer;
  final int? customerId;
  const OrderScreen({Key? key, this.fromNavBar = true, this.isCustomer = false, this.customerId}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    if(widget.isCustomer){
      Get.find<CustomerController>().getCustomerWiseOrderListList(widget.customerId, 1);
    }else{
      Get.find<OrderController>().getOrderList(1, isUpdate: false);
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            if(widget.isCustomer){
              Get.find<CustomerController>().getCustomerWiseOrderListList(widget.customerId, 1);
            }else{
              Get.find<OrderController>().getOrderList(1);
            }

          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(children: [
                  CustomHeaderWidget(title: 'order_list'.tr, headerImage: Images.peopleIcon),
                  widget.isCustomer?  CustomerWiseOrderListWidget(scrollController: _scrollController, customerId: widget.customerId) :
                  OrderListWidget(scrollController: _scrollController)
                ],),
              )
            ],
          ),
        ),
      ),

    );
  }
}
