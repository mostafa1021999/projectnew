import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_dialog_widget.dart';
import 'package:six_pos/features/employe_role/controllers/employee_controller.dart';
import 'package:six_pos/features/employe_role/controllers/employee_role_controller.dart';
import 'package:six_pos/features/employe_role/domain/enums/employee_management_enum.dart';
import 'package:six_pos/features/employe_role/domain/models/employee_model.dart';
import 'package:six_pos/features/employe_role/domain/models/role_model.dart';
import 'package:six_pos/features/employe_role/screens/add_employee_screen.dart';
import 'package:six_pos/features/employe_role/screens/add_role_screen.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class RoleItemWidget extends StatelessWidget {
  final RoleItemModel? role;
  final Employee? employee;
  final EmployeeManagement employeeManagement;
  const RoleItemWidget({Key? key, this.role, this.employee, required this.employeeManagement}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeBorder,
      ),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeExtraSmall,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
          child: Row(children: [

            Expanded(child: Text(
             employeeManagement == EmployeeManagement.role ? (role?.name ?? '') :  '${employee?.fName} ${employee?.lName}', maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
            )),
            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

            InkWell(
              onTap: (){
                switch(employeeManagement) {
                  case EmployeeManagement.role:
                    Get.to(()=> AddRoleScreen(role: role));
                    break;
                  case EmployeeManagement.employee:
                    Get.to(()=> AddEmployeeScreen(employee: employee));
                    break;
                }
              },
              child: SizedBox(
                width: Dimensions.iconSizeDefault,
                child: Image.asset(Images.editIcon),
              ),
            ),

            const SizedBox(width: Dimensions.paddingSizeExtraSmall),


            InkWell(
              onTap: (){
                showAnimatedDialogHelper(context, GetBuilder<RoleController>(builder: (roleController) {
                  return GetBuilder<EmployeeController>(
                    builder: (employeeController) {
                      return CustomDialogWidget(
                        isLoading: employeeController.isLoading || roleController.isLoading,
                        delete: true,
                        icon: Icons.exit_to_app_rounded,
                        title: '',
                        description: employeeManagement == EmployeeManagement.employee
                            ?  'are_you_sure_you_want_to_delete_this_role'.tr
                            :  'are_you_sure_you_want_to_delete_this_employee'.tr,
                        onTapFalse:() => Navigator.of(context).pop(true),
                        onTapTrue: () async {
                          if(employeeManagement == EmployeeManagement.employee) {
                           await employeeController.deleteEmployeeById(employee?.id);
                          }else {
                            await roleController.deleteRoleById(role?.id);

                          }
                        },
                        onTapTrueText: 'yes'.tr,
                        onTapFalseText: 'cancel'.tr,
                      );
                    }
                  );
                }
                ),
                  dismissible: false,
                  isFlip: true,
                );
              },
              child: SizedBox(
                width: Dimensions.iconSizeDefault,
                child: Image.asset(Images.deleteIcon),
              ),
            ),


          ],),
        ),
      ),
    );
  }
}
