import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_dialog_widget.dart';
import 'package:six_pos/features/category/screens/add_new_sub_category_screen.dart';
class SubCategoryCardWidget extends StatelessWidget {
  final SubCategories? subCategory;
  const SubCategoryCardWidget({Key? key, this.subCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeBorder,
        horizontal: Dimensions.paddingSizeDefault,
      ),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
        child: Row(children: [

          Expanded(child: Text(
            subCategory!.name!, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
          )),

          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          InkWell(
            onTap: ()=> Get.to(AddNewSubCategoryScreen(subCategory: subCategory)),
            child: SizedBox(width: Dimensions.iconSizeDefault,
                child: Image.asset(Images.editIcon)),
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),


          GetBuilder<CategoryController>(
            builder: (categoryController) {
              return InkWell(
                onTap: (){
                  showAnimatedDialogHelper(context,
                      CustomDialogWidget(
                        delete: true,
                        icon: Icons.exit_to_app_rounded, title: '',
                        description: 'are_you_sure_you_want_to_delete_sub_category'.tr, onTapFalse:() => Get.back(),
                        onTapTrue:() {
                          categoryController.deleteSubCategory(subCategory!);
                        },
                        onTapTrueText: 'yes'.tr, onTapFalseText: 'cancel'.tr,
                      ),
                      dismissible: false,
                      isFlip: true);
                },
                child: SizedBox(width: Dimensions.iconSizeDefault,
                    child: Image.asset(Images.deleteIcon)),
              );
            }
          ),


        ],),
      ),
    );
  }
}
