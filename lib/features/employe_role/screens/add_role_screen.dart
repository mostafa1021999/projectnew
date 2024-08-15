import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/common/widgets/required_title_widget.dart';
import 'package:six_pos/features/employe_role/controllers/employee_role_controller.dart';
import 'package:six_pos/features/employe_role/domain/models/role_model.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';

class AddRoleScreen extends StatefulWidget {
  final RoleItemModel? role;
  const AddRoleScreen({Key? key, this.role}) : super(key: key);


  @override
  State<AddRoleScreen> createState() => _AddRoleScreenState();
}

class _AddRoleScreenState extends State<AddRoleScreen> {
  final TextEditingController _roleTextController = TextEditingController();
  final FocusNode _roleFocusNode = FocusNode();

  @override
  void initState() {
    final RoleController employeeRoleController = Get.find<RoleController>();

    if(widget.role != null) {
      _roleTextController.text = widget.role?.name ?? '';

    }
    employeeRoleController.onChangeModuleAllSelect(null, isUpdate: false);
    employeeRoleController.initializeModuleList(widget.role);


    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      endDrawer: const CustomDrawerWidget(),
      appBar: const CustomAppBarWidget(isBackButtonExist: true,),
      body: GetBuilder<RoleController>(builder: (employeeController) {
        return Column(children: [
          Expanded(child: SingleChildScrollView(
            child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
              const SizedBox(height: Dimensions.paddingSizeDefault,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  CustomHeaderWidget(
                    title: widget.role != null ? 'edit_role'.tr : 'add_role'.tr,
                    headerImage: Images.updateEmployee,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge,),

                  RequiredTitleWidget(title:'role_name'.tr),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomTextFieldWidget(
                    controller: _roleTextController,
                    focusNode: _roleFocusNode,
                    hintText: 'brand_name_hint'.tr,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    RequiredTitleWidget(title:'module_permission'.tr),

                    Row(children: [
                      Text('all'.tr, style: fontSizeMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                      )),

                      Checkbox(
                          value: employeeController.isModuleAllSelect ?? false,
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                          onChanged:(bool? value) {
                            employeeController.onChangeModuleAllSelect(value);

                          },
                          visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                        ),
                    ]),

                  ]),


                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: employeeController.selectedModuleList?.length,
                    itemBuilder: (context, index) => IntrinsicHeight(
                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Checkbox(
                          value: employeeController.selectedModuleList?[index].status,
                          activeColor: Theme.of(context).primaryColor,
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                          onChanged:(bool? value) {
                            employeeController.onChangeModuleStatus(index, value ?? false);

                          },
                          visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                        ),
                      
                        Flexible(child: Text(
                          employeeController.permissionModule?[index].tr ?? '',
                        )),
                      ]),
                    ),
                  )

                ]),
              ),


            ]),
          )),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
            child: CustomButtonWidget(
              isLoading: employeeController.isLoading,
              buttonText: widget.role != null ? 'update'.tr : 'save'.tr,
              onPressed: (){
                if(_roleTextController.text.trim().isNotEmpty) {
                  employeeController.addOrUpdateRole(_roleTextController.text, widget.role?.id);

                }else {
                  showCustomSnackBarHelper('add_role_name_field'.tr);
                }
              },
            ),
          ),
        ]);
      }),
    );
  }
}
