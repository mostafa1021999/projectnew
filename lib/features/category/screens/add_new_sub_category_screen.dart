import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/category_controller.dart';
import 'package:six_pos/common/models/sub_category_model.dart';
import 'package:six_pos/features/category/domain/models/category_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
class AddNewSubCategoryScreen extends StatefulWidget {
  final SubCategories? subCategory;
  const AddNewSubCategoryScreen({Key? key, this.subCategory}) : super(key: key);

  @override
  State<AddNewSubCategoryScreen> createState() => _AddNewSubCategoryScreenState();
}

class _AddNewSubCategoryScreenState extends State<AddNewSubCategoryScreen> {
  final TextEditingController _subCategoryController = TextEditingController();
  final FocusNode _subCategoryFocusNode = FocusNode();
  int? parentCategoryId = 0;
  String  parentCategoryName = '';
  late bool update;

  @override
  void initState() {
    super.initState();

    _initLoad();


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),
      appBar: const CustomAppBarWidget(),
      body: GetBuilder<CategoryController>(
          builder: (categoryController) {
            return Column(crossAxisAlignment : CrossAxisAlignment.start, children: [

              CustomHeaderWidget(title: update? 'update_sub_category'.tr : 'add_sub_category'.tr, headerImage: Images.addNewCategory),
              const SizedBox(height: Dimensions.paddingSizeDefault,),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Column(crossAxisAlignment : CrossAxisAlignment.start, children: [

                 if(!update) Column(crossAxisAlignment : CrossAxisAlignment.start, children: [
                    Text('select_category_name'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(color: Theme.of(context).cardColor,
                          border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                      child: DropdownButton<int>(
                        hint: Text('select'.tr),
                        value: categoryController.selectedCategoryId,
                        items: categoryController.categoryModel?.categoriesList?.map((Categories? value) {
                          return DropdownMenuItem<int>(
                              value: value?.id,
                              child: Text('${value?.name}'));
                        }).toList(),
                        onChanged: (int? value) {
                          categoryController.setCategoryIndex(value!, true);
                        },
                        isExpanded: true, underline: const SizedBox(),),),
                    const SizedBox(height: Dimensions.paddingSizeSmall),
                  ]),


                  Text('sub_category_name'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge),),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomTextFieldWidget(

                    controller: _subCategoryController,
                    focusNode: _subCategoryFocusNode,
                    hintText: 'sub_category_hint'.tr,),
                  const SizedBox(height: Dimensions.paddingSizeSmall),


                ],),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge,),

              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                child: CustomButtonWidget(
                  isLoading: categoryController.isLoading,
                  buttonText: update? 'update'.tr : 'save'.tr,
                  onPressed: (){
                    if(categoryController.selectedCategoryId != null && (categoryController.categoryModel?.categoriesList?.isNotEmpty ?? false)){
                      String subCategoryName  = _subCategoryController.text.trim();
                      int? parentId = update ? widget.subCategory?.parentId : categoryController.selectedCategoryId!;
                      int? id = update? widget.subCategory?.id : null;
                      categoryController.addSubCategory(subCategoryName, id,parentId, update);
                    }else{
                      showCustomSnackBarHelper('select_category'.tr);
                    }

                  },
                ),
              ),


            ],);
          }
      ),
    );
  }

  void _initLoad() {
    update = widget.subCategory != null;
    if(update){
      _subCategoryController.text = widget.subCategory!.name!;
      parentCategoryId = widget.subCategory!.parentId;
    }else{
      Get.find<CategoryController>().setCategoryAndSubCategoryEmpty();

    }
  }
}
