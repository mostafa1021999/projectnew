import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
class AddNewCategoryScreen extends StatefulWidget {
  final Categories? category;
  const AddNewCategoryScreen({Key? key, this.category}) : super(key: key);

  @override
  State<AddNewCategoryScreen> createState() => _AddNewCategoryScreenState();
}

class _AddNewCategoryScreenState extends State<AddNewCategoryScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final FocusNode _categoryFocusNode = FocusNode();
   late bool update;
   @override
  void initState() {
    super.initState();

    update = widget.category != null;
    if(update){
      _categoryController.text = widget.category!.name!;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: GetBuilder<CategoryController>(
        builder: (categoryController) {
          return Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
            // const CustomAppBar(isBackButtonExist: true,),

            const SizedBox(height: Dimensions.paddingSizeDefault,),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
                CustomHeaderWidget(title: update ? 'update_category'.tr : 'add_category'.tr, headerImage: Images.addNewCategory),

                Text('category_name'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                CustomTextFieldWidget(
                controller: _categoryController,
                focusNode: _categoryFocusNode,
                hintText: 'category_name'.tr,),
                const SizedBox(height: Dimensions.paddingSizeSmall),


                Text('category_image'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Align(alignment: Alignment.center, child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    child: categoryController.categoryImage != null ?  Image.file(File(categoryController.categoryImage!.path),
                      width: 150, height: 120, fit: BoxFit.cover,
                    ) :widget.category!=null? FadeInImage.assetNetwork(
                      placeholder: Images.placeholder,
                      image: '${Get.find<SplashController>().baseUrls!.categoryImageUrl}/${widget.category!.image ?? ''}',
                      height: 120, width: 150, fit: BoxFit.cover,
                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                          height: 120, width: 150, fit: BoxFit.cover),
                    ):Image.asset(Images.placeholder,height: 120,
                      width: 150, fit: BoxFit.cover,),
                  ),
                  Positioned(
                    bottom: 0, right: 0, top: 0, left: 0,
                    child: InkWell(
                      onTap: () => categoryController.pickImage(false),
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

            categoryController.isLoading?
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
              child: CustomButtonWidget(buttonText: update? 'update'.tr :'save'.tr,  onPressed: (){
                int? categoryId  =  update? widget.category!.id : null;
                String categoryName  =  _categoryController.text.trim();
                categoryController.addCategory(categoryName, categoryId, update);
              },),
            ),


          ],);
        }
      ),
    );
  }
}
