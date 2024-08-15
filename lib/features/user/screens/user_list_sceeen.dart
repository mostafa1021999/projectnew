import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/user/controllers/customer_controller.dart';
import 'package:six_pos/features/user/controllers/supplier_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_search_field_widget.dart';
import 'package:six_pos/common/widgets/secondary_header_widget.dart';
import 'package:six_pos/features/user/widgets/customer_list_widget.dart';
import 'package:six_pos/features/user/widgets/supplier_list_widget.dart';

class UserListScreen extends StatefulWidget {
  final bool isCustomer;
  const UserListScreen({Key? key, this.isCustomer = false}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    if(widget.isCustomer) {
      Get.find<CustomerController>().getCustomerList(1, isUpdate: false);
    }else {
      Get.find<SupplierController>().getSupplierList(1);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),
      appBar:  const CustomAppBarWidget(isBackButtonExist: true),
      body: SafeArea(
        child: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {

          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child:  Column(children: [
                  CustomHeaderWidget(title: widget.isCustomer? 'customer_list'.tr : 'supplier_list'.tr, headerImage: Images.peopleIcon),

                  widget.isCustomer?
                  GetBuilder<CustomerController>(
                      builder: (customerController) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeSmall),
                          child: CustomSearchFieldWidget(
                            controller: searchController,
                            hint: 'search_customer'.tr,
                            prefix: Icons.search,
                            iconPressed: () => (){},
                            onSubmit: (text) => (){},
                            onChanged: (value){
                              customerController.filterCustomerList(value);
                            },
                            isFilter: false,
                          ),
                        );
                      }
                  ): GetBuilder<SupplierController>(
                      builder: (supplierController) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeSmall),
                          child: CustomSearchFieldWidget(
                            controller: searchController,
                            hint: 'search_supplier'.tr,
                            prefix: Icons.search,
                            iconPressed: () => (){},
                            onSubmit: (text) => (){},
                            onChanged: (value){
                              supplierController.searchSupplier(value);
                            },
                            isFilter: false,
                          ),
                        );
                      }
                  ),

                  SecondaryHeaderWidget(
                    key: UniqueKey(),
                    title:widget.isCustomer? 'customer_info'.tr : 'supplier_info'.tr,
                    showOwnTitle: true,
                    isSerial: true,
                  ),

                  widget.isCustomer? CustomerListWidget(
                    scrollController: _scrollController,
                  ) : SupplierListWidget(scrollController: _scrollController)

                ]),
              )
            ],
          ),
        ),
      ),


    );
  }
}
