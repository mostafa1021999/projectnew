import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/employe_role/controllers/employee_controller.dart';
import 'package:six_pos/features/employe_role/domain/enums/employee_management_enum.dart';
import 'package:six_pos/features/employe_role/screens/add_employee_screen.dart';
import 'package:six_pos/features/employe_role/widgets/role_item_widget.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({Key? key}) : super(key: key);


  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {

    Get.find<EmployeeController>().getEmployeeList(1, isUpdate: false);

    super.initState();
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
              await Get.find<EmployeeController>().getEmployeeList(1, isUpdate: false);
            },
            child: CustomScrollView(controller: _scrollController, slivers: [
              SliverToBoxAdapter(child: Column(children: [
                CustomHeaderWidget(title: 'employee_list'.tr, headerImage: Images.employeeList),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                GetBuilder<EmployeeController>(
                    builder: (employeeController) {
                      return employeeController.employeeModel == null ? const CustomLoaderWidget(
                      ) : (employeeController.employeeModel?.employees?.isNotEmpty ?? false) ? PaginatedListWidget(
                        scrollController: _scrollController,
                        onPaginate: (int? offset) async => await employeeController.getEmployeeList(offset ?? 1),
                        totalSize: employeeController.employeeModel?.totalSize,
                        offset: employeeController.employeeModel?.offset,
                        itemView: ListView.builder(
                          shrinkWrap: true,
                          itemCount: employeeController.employeeModel?.employees?.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (ctx,index){
                            return RoleItemWidget(
                              employee: employeeController.employeeModel?.employees?[index],
                              employeeManagement: EmployeeManagement.employee,
                            );
                          },
                        ),
                      ) : const NoDataWidget();
                    }
                )

              ])),

            ])),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Image.asset(Images.addCategoryIcon),
        onPressed: () {
          Get.to(()=> const AddEmployeeScreen());
        },
      ),
    );
  }
}
