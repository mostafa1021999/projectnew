
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/unit/controllers/unit_controller.dart';
import 'package:six_pos/features/unit/domain/models/unit_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
class AddNewUnitScreen extends StatefulWidget {
  final Units? unit;
  const AddNewUnitScreen({Key? key, this.unit}) : super(key: key);

  @override
  State<AddNewUnitScreen> createState() => _AddNewUnitScreenState();
}

class _AddNewUnitScreenState extends State<AddNewUnitScreen> {
  late bool update;
  final TextEditingController _unitController = TextEditingController();
  final FocusNode _unitFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    update = widget.unit != null;
    if(update){
      _unitController.text = widget.unit!.unitType!;
    }

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      endDrawer: const CustomDrawerWidget(),
      body: GetBuilder<UnitController>(
          builder: (unitController) {
            return Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
              const CustomAppBarWidget(isBackButtonExist: true,),

              const SizedBox(height: Dimensions.paddingSizeDefault,),
              CustomHeaderWidget(title: update? 'update_unit'.tr : 'add_unit'.tr, headerImage: Images.productUnit),
              const SizedBox(height: Dimensions.paddingSizeDefault,),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [


                  Text('unit_name'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomTextFieldWidget(
                    controller: _unitController,
                    focusNode: _unitFocusNode,
                    hintText: 'unit_name_hint'.tr,),
                  const SizedBox(height: Dimensions.paddingSizeSmall),


                ],),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge,),

              unitController.isLoading?
              Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal : MediaQuery.of(context).size.width/2-30,
                        vertical: Dimensions.paddingSizeLarge),
                    child: Container(alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(25)
                      ),
                      width: 30,height: 30,child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),),
                  ),
                ],
              ):
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                child: unitController.isLoading ? const CircularProgressIndicator() :  CustomButtonWidget(
                    buttonText: update? 'update'.tr : 'save'.tr,  onPressed: () async {
                  String unitName  =  _unitController.text.trim();
                  int? unitId = update ? widget.unit!.id : null;
                  await unitController.addUnit(unitName, unitId, update);
                }),
              ),


            ],);
          }
      ),
    ));
  }
}
