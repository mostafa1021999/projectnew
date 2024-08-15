import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/brand/domain/models/brand_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/common/widgets/required_title_widget.dart';

class AddNewBrandScreen extends StatefulWidget {
  final Brands? brand;
  const AddNewBrandScreen({Key? key, this.brand}) : super(key: key);

  @override
  State<AddNewBrandScreen> createState() => _AddNewBrandScreenState();
}

class _AddNewBrandScreenState extends State<AddNewBrandScreen> {
  final TextEditingController _brandController = TextEditingController();
  final FocusNode _brandFocusNode = FocusNode();

  late bool update;

  @override
  void initState() {
    super.initState();
    update = widget.brand != null;
    if(update){
      _brandController.text = widget.brand!.name!;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),
      body: GetBuilder<BrandController>(
          builder: (brandController) {
            return Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
              const CustomAppBarWidget(isBackButtonExist: true,),

              const SizedBox(height: Dimensions.paddingSizeDefault,),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
                  CustomHeaderWidget(title: update ? 'edit_brand'.tr : 'add_brand'.tr, headerImage: Images.addNewCategory),

                  RequiredTitleWidget(title:'brand_name'.tr),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomTextFieldWidget(
                    controller: _brandController,
                    focusNode: _brandFocusNode,
                    hintText: 'brand_name_hint'.tr,),
                  const SizedBox(height: Dimensions.paddingSizeSmall),


                  RequiredTitleWidget(title:'brand_image'.tr),
                  const SizedBox(height: Dimensions.paddingSizeSmall),


                  Align(alignment: Alignment.center, child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      child: brandController.brandImage != null ?  Image.file(File(brandController.brandImage!.path),
                        width: 150, height: 120, fit: BoxFit.cover,
                      ) :widget.brand!=null? FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        image: '${Get.find<SplashController>().baseUrls!.brandImageUrl}/${widget.brand!.image ?? ''}',
                        height: 120, width: 150, fit: BoxFit.cover,
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                            height: 120, width: 150, fit: BoxFit.cover),
                      ):Image.asset(Images.placeholder,height: 120,
                        width: 150, fit: BoxFit.cover,),
                    ),
                    Positioned(
                      bottom: 0, right: 0, top: 0, left: 0,
                      child: InkWell(
                        onTap: () => brandController.pickImage(false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                            border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              border: Border.all(width: 2, color: Colors.white),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ])),

                ],),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge,),


              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                child: CustomButtonWidget(
                  isLoading: brandController.isLoading,
                  buttonText: update? 'update'.tr : 'save'.tr,  onPressed: (){
                  int? brandId  =  widget.brand?.id;
                  String brandName  =  _brandController.text.trim();
                  if(brandName.isEmpty){
                    showCustomSnackBarHelper('brand_name_is_required'.tr);
                  }else if(brandController.brandImage == null && !update){
                    showCustomSnackBarHelper('brand_image_is_required'.tr);
                  }else{
                    brandController.addBrand(brandName, brandId);
                  }
                },),
              ),


            ],);
          }
      ),
    );
  }
}
