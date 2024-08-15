import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/features/unit/screens/add_new_unit_screen.dart';
import 'package:six_pos/features/unit/widgets/unit_list_view.dart';
class UnitListViewScreen extends StatefulWidget {
  const UnitListViewScreen({Key? key}) : super(key: key);

  @override
  State<UnitListViewScreen> createState() => _UnitListViewScreenState();
}

class _UnitListViewScreenState extends State<UnitListViewScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<UnitController>().getUnitList(1);
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

          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    CustomHeaderWidget(title: 'unit_list'.tr, headerImage: Images.categories),
                    const SizedBox(height: Dimensions.paddingSizeDefault    ),
                    UnitListWidget(scrollController: _scrollController,),
                    const SizedBox(height: 100),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Get.to(const AddNewUnitScreen());
        },child: Image.asset(Images.addCategoryIcon),),
    );
  }
}
