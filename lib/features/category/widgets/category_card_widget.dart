import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/widgets/custom_image_widget.dart';
import 'package:six_pos/common/widgets/custom_switch_widget.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_dialog_widget.dart';
import 'package:six_pos/features/category/screens/add_new_category_screen.dart';
class CategoryCardWidget extends StatelessWidget {
  final Categories? category;
  final int? index;
  const CategoryCardWidget({Key? key, this.category, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeBorder),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeExtraSmall),
        child: Row(children: [
          Container(
            height: Dimensions.productImageSize,
            width: Dimensions.productImageSize,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: CustomImageWidget(
                fit: BoxFit.cover,
                height: Dimensions.productImageSize,
                image: '${Get.find<SplashController>().baseUrls?.categoryImageUrl}/${category!.image}',
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          Expanded(child: Text(category?.name ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
            style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),)),

          GetBuilder<CategoryController>(
            builder: (categoryController) {
              return CustomSwitchWidget(
                  value: category?.status == 1,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) => categoryController.onChangeCategoryStatus(
                    category?.id, category?.status == 1 ? 0 : 1, index,
                  ));
            }
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          InkWell(
            onTap: ()=> Get.to(AddNewCategoryScreen(category: category,)),
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
                        description: 'are_you_sure_you_want_to_delete_category'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                        onTapTrue:() {
                          categoryController.deleteCategory(category!.id);
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
