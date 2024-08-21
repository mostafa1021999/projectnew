import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';

import '../../../util/images.dart';

class ExtraDiscountDialogWidget extends StatefulWidget {
  final double totalAmount;
  final bool isBank ;
  final bool sendReceipt ;
  ExtraDiscountDialogWidget({Key? key, required this.totalAmount,required this.isBank,required this.sendReceipt}) ;

  @override
  State<ExtraDiscountDialogWidget> createState() => _ExtraDiscountDialogWidget();
}
class _ExtraDiscountDialogWidget extends State<ExtraDiscountDialogWidget> {
  get productRepo => null;
  File? _shopLogo;
  List<bool> checklist = [];
  TextEditingController dataController=TextEditingController();
  Future<void> _handleExtraDiscountSubmit() async{
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickedFile!=null){
      setState(() async{
        _shopLogo=File(pickedFile.path);
      });}else{
      print('No image selected.');
    }
  }
  void changeChecklistValue(int checklistIndex, bool value) {
    setState(() {
      checklist[checklistIndex] = value;
    });
  }
  @override
  void initState() {
    checklist = List.generate(
          sendReceipt.length,(index)=>false,
    );
    super.initState();
  }
  Widget checkList(isChecked,onChange,addNewName)=>CheckboxListTile(
      title: Text(
        addNewName, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start,
        style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),
      ),

      value: isChecked,
      onChanged: onChange,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: ColorResources.primaryColor,
      checkColor:Colors.white
  );

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
      child: GetBuilder<CartController>(
        builder: (cartController) {
          return Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            height:widget.sendReceipt? 220:350,child:widget.sendReceipt?
              GridView.count(
                  physics: const BouncingScrollPhysics(),
                  childAspectRatio: 1/0.5,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.2,
                  children:List.generate(sendReceipt.length, (index) {
                   final bool isChecked = checklist[index];
                    return checkList(isChecked, (bool? value){changeChecklistValue(index,value??false);}, sendReceipt[index]);
                  }) ,
                crossAxisCount: 2,)
                :Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
              if(!widget.isBank)
              Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: Text('extra_discount'.tr, style: fontSizeMedium.copyWith(color: Theme.of(context).secondaryHeaderColor)),
            ),
              if(!widget.isBank)
              GetBuilder<CartController>(
              builder: (cartController) {
                return Container(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('discount_type'.tr,
                      style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(width: .7,color: Theme.of(context).hintColor.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),

                      ),
                      child: DropdownButton<String>(
                        value: cartController.discountTypeIndex == 0 ?'amount'  :  'percent',
                        items: <String>['amount','percent'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.tr),
                          );
                        }).toList(),
                        onChanged: (value) {
                          cartController.setSelectedDiscountType(value);
                          cartController.setDiscountTypeIndex(value == 'amount' ? 0 : 1, true);

                        },
                        isExpanded: true,
                        underline: const SizedBox(),
                      ),
                    ),
                  ]),
                );
              }
            ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              CustomFieldWithTitleWidget(
              customTextField: CustomTextFieldWidget(hintText: 'discount_hint'.tr,
                controller: cartController.extraDiscountController,
                inputType: TextInputType.number,
              ),
              title: widget.isBank?'transaction_number'.tr:'discount_percentage'.tr,
              requiredField: true,
            ),
              if(widget.isBank)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeSmall,
                    horizontal: Dimensions.paddingSizeDefault,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: 'transaction_photo'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                if(widget.isBank)
                  InkWell(
                            onTap: (){
                                  _handleExtraDiscountSubmit();
                            },
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  border: Border.all(width: 1, color: Theme.of(context).primaryColor),
                                ),
                                child:_shopLogo!=null?
                                Container(
                                    width: 100,
                                    height: 70,
                                    child: Image.file(_shopLogo!))
                                    :Container(
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
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                child: Row(children: [
                  Expanded(child: CustomButtonWidget(buttonText: 'cancel'.tr,
                      buttonColor: Theme.of(context).hintColor,textColor: ColorResources.getTextColor(),isClear: true,
                      onPressed: ()=>Get.back())),
                  const SizedBox(width: Dimensions.paddingSizeDefault),
                  Expanded(child: CustomButtonWidget(buttonText: 'apply'.tr,onPressed: (){
                    cartController.applyCouponCodeAndExtraDiscount(widget.totalAmount);
                    Get.back();
                  },)),
                ],),
              ),
          ],),);
        }
      ),
    );
  }
}
List sendReceipt=['SMS','Whatsapp','E-Mail'];
