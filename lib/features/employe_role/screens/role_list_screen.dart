import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/employe_role/controllers/employee_role_controller.dart';
import 'package:six_pos/features/employe_role/domain/enums/employee_management_enum.dart';
import 'package:six_pos/features/employe_role/screens/add_role_screen.dart';
import 'package:six_pos/features/employe_role/widgets/role_item_widget.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';

class EmployeeRoleListScreen extends StatefulWidget {
  const EmployeeRoleListScreen({Key? key}) : super(key: key);


  @override
  State<EmployeeRoleListScreen> createState() => _EmployeeRoleListScreenState();
}

class _EmployeeRoleListScreenState extends State<EmployeeRoleListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final RoleController employeeRoleController = Get.find<RoleController>();
    employeeRoleController.getRoleList(1, isUpdate: false);

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
           await Get.find<RoleController>().getRoleList(1);
          },
          child: CustomScrollView(controller: _scrollController, slivers: [
            SliverToBoxAdapter(child: Column(children: [
              CustomHeaderWidget(title: 'role_list'.tr, headerImage: Images.employeeRole),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              GetBuilder<RoleController>(
                builder: (employeeRoleController) {
                  return employeeRoleController.roleModel == null ? const CustomLoaderWidget(
                  ) : (employeeRoleController.roleModel?.roleList?.isNotEmpty ?? false) ? PaginatedListWidget(
                    scrollController: _scrollController,
                    onPaginate: (int? offset) async => await employeeRoleController.getRoleList(offset ?? 1),
                    totalSize: employeeRoleController.roleModel?.totalSize,
                    offset: employeeRoleController.roleModel?.offset,
                    itemView: ListView.builder(
                      shrinkWrap: true,
                      itemCount: employeeRoleController.roleModel?.roleList?.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (ctx,index){
                        return RoleItemWidget(
                          role: employeeRoleController.roleModel?.roleList?[index],
                          employeeManagement: EmployeeManagement.role,

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
          Get.to(()=> const AddRoleScreen());
        },
      ),
    );
  }
}
