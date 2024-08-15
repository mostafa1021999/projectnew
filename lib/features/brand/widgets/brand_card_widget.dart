import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_dialog_widget.dart';
import 'package:six_pos/features/brand/screens/add_new_brand_screen.dart';
class BrandCardWidget extends StatelessWidget {
  final Brands? brand;
  const BrandCardWidget({Key? key, this.brand}) : super(key: key);

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
              child: FadeInImage.assetNetwork(
                placeholder: Images.placeholder, fit: BoxFit.cover,
                height: Dimensions.productImageSize,
                image: '${Get.find<SplashController>().baseUrls!.brandImageUrl}/${brand!.image}',
                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                  fit: BoxFit.cover,height: Dimensions.productImageSize,),
              ),
            ),
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          Expanded(child: Text(brand!.name!, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),)),

          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          InkWell(
            onTap: ()=> Get.to(AddNewBrandScreen(brand: brand,)),
            child: SizedBox(width: Dimensions.iconSizeDefault,
                child: Image.asset(Images.editIcon)),
          ),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),


          GetBuilder<BrandController>(
            builder: (brandController) {
              return InkWell(
                onTap: (){
                  showAnimatedDialogHelper(context,
                      CustomDialogWidget(
                        delete: true,
                        icon: Icons.exit_to_app_rounded, title: '',
                        description: 'are_you_sure_you_want_to_delete_brand'.tr, onTapFalse:() => Navigator.of(context).pop(true),
                        onTapTrue:() {
                          brandController.deleteBrand(brand!.id);
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
