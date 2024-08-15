import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/shop/controllers/profile_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/features/shop/widgets/dropdown_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';

class ShopInfoFieldWidget extends StatefulWidget {
  final ConfigModel? configModel;
  final bool isBusinessInfo;
  const ShopInfoFieldWidget({Key? key, this.isBusinessInfo = false, this.configModel}) : super(key: key);

  @override
  State<ShopInfoFieldWidget> createState() => _ShopInfoFieldWidgetState();
}

class _ShopInfoFieldWidgetState extends State<ShopInfoFieldWidget> {
  TextEditingController shopNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController paginationTextController = TextEditingController();
  TextEditingController footerTextController = TextEditingController();
  TextEditingController stockLimitController = TextEditingController();
  TextEditingController vatRegistrationNoController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String? currency,  countryIsoCode, selectedTimeZone;
  @override
  void initState() {
    super.initState();
    shopNameController.text = widget.configModel?.businessInfo?.shopName ?? '';
    emailController.text = widget.configModel?.businessInfo?.shopEmail ?? '';
    phoneController.text = widget.configModel?.businessInfo?.shopPhone ?? '';
    addressController.text = widget.configModel?.businessInfo?.shopAddress ?? '';
    currency = widget.configModel?.businessInfo?.currency;
    Get.find<ProfileController>().setValueForSelectedTimeZone(widget.configModel?.businessInfo?.timeZone);
    countryIsoCode = widget.configModel?.businessInfo?.country;
    paginationTextController.text = widget.configModel?.businessInfo?.paginationLimit ?? '';
    footerTextController.text = widget.configModel?.businessInfo?.footerText ?? '';
    stockLimitController.text = widget.configModel?.businessInfo?.stockLimit ?? '';
    vatRegistrationNoController.text = widget.configModel?.businessInfo?.vat ?? '';

  }



  @override
  Widget build(BuildContext context) {
    final SplashController splashController = Get.find<SplashController>();

    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   if(!widget.isBusinessInfo) CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'enter_shop_name'.tr,
                      controller: shopNameController),
                      title: 'shop_name'.tr,
                      requiredField: true,
                    ),

                    if(widget.isBusinessInfo) CustomFieldWithTitleWidget(
                      title: 'vat_registration_no'.tr,
                      customTextField: CustomTextFieldWidget(
                          controller: vatRegistrationNoController),
                      requiredField: true,
                    ),

                    if(widget.isBusinessInfo) CustomFieldWithTitleWidget(
                      title: 'country'.tr,
                      customTextField: Container(
                        padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 0.5)
                        ),
                        child: DropdownWidget(
                          initialValue: countryIsoCode,
                          onValuePicked: (Country? value){
                            countryIsoCode = value?.isoCode;

                          },
                          itemBuilder: (country)=> BuildDropdownItem(country: country, isCountry: true),
                        ),
                      ),
                      requiredField: true,
                    ),


                   if(!widget.isBusinessInfo) CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'enter_email_address'.tr,
                      controller: emailController),
                      title: 'email'.tr,
                      requiredField: true,
                    ),

                    if(widget.isBusinessInfo) CustomFieldWithTitleWidget(
                      title: 'currency'.tr,
                      customTextField: Container(
                        padding: const EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                            border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3), width: 0.5)
                        ),
                        child: DropdownWidget(
                          initialValue: CountryPickerUtils.getCountryByCurrencyCode(currency!).isoCode,
                          onValuePicked: (Country? value){
                            currency = value?.currencyCode;
                          },
                          itemBuilder: (country)=> BuildDropdownItem(country: country, isCountry: false),
                        ),
                      ),
                      requiredField: true,
                    ),

                    if(!widget.isBusinessInfo) CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'enter_phone_number'.tr,
                      controller: phoneController),
                      title: 'phone'.tr,
                      requiredField: true,
                    ),



                    if(widget.isBusinessInfo)Padding(
                      padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0, Dimensions.paddingSizeDefault,0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('time_zone'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor)),
                              Text('*', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor)),
                            ],
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeBorder),
                              border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                            ),
                            child: DropdownSearch<String>(
                              items: profileController.timeZone,
                              selectedItem: profileController.selectedTimeZone,
                              onChanged: (val) {
                                selectedTimeZone = val;
                                profileController.setValueForSelectedTimeZone(val);
                              },
                              dropdownDecoratorProps:  DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'select'.tr,
                                ),
                              ),
                              popupProps: PopupPropsMultiSelection.menu(
                                showSearchBox: true,
                                showSelectedItems: true,

                                searchFieldProps: TextFieldProps(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        if(searchController.text.isEmpty){
                                          Get.back();
                                        }else{
                                          searchController.clear();
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    if(!widget.isBusinessInfo) CustomFieldWithTitleWidget(
                      customTextField: CustomTextFieldWidget(hintText: 'enter_address'.tr, maxLines: 3,
                      controller: addressController),
                      title: 'address'.tr,
                      requiredField: true,
                    ),


                    if(widget.isBusinessInfo) CustomFieldWithTitleWidget(
                      title: 'reorder_level'.tr,
                      customTextField: CustomTextFieldWidget(
                          controller: stockLimitController),
                      requiredField: true,
                    ),



                    if(!widget.isBusinessInfo) Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.paddingSizeSmall,
                        horizontal: Dimensions.paddingSizeDefault,
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'upload_shop_logo'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
                          children: <TextSpan>[
                            TextSpan(text: ' * ${'ratio'.tr}', style: fontSizeBold.copyWith(color: Theme.of(context).colorScheme.error)),
                          ],
                        ),
                      ),
                    ),
                   if(!widget.isBusinessInfo) Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Align(alignment: Alignment.center, child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          child: profileController.shopLogo != null ?  Image.file(File(profileController.shopLogo!.path),
                            width: 150, height: 120, fit: BoxFit.cover,
                          ) :widget.configModel!.businessInfo!.shopLogo!=null? FadeInImage.assetNetwork(
                            placeholder: Images.placeholder,
                            image: '${Get.find<SplashController>().baseUrls!.shopImageUrl}/${widget.configModel!.businessInfo!.shopLogo ?? ''}',
                            height: 120, width: 150, fit: BoxFit.cover,
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                                height: 120, width: 150, fit: BoxFit.cover),
                          ):Image.asset(Images.placeholder,height: 120,
                            width: 150, fit: BoxFit.cover,),
                        ),
                        Positioned(
                          bottom: 0, right: 0, top: 0, left: 0,
                          child: InkWell(
                            onTap: () => profileController.pickImage(false),
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
                    ),

                    if(widget.isBusinessInfo) CustomFieldWithTitleWidget(
                      title: 'pagination_limit'.tr,
                      customTextField: CustomTextFieldWidget(
                        inputType: TextInputType.number,
                          controller: paginationTextController),
                      requiredField: true,
                    ),

                    if(widget.isBusinessInfo) CustomFieldWithTitleWidget(
                      title: 'footer_text'.tr,
                      customTextField: CustomTextFieldWidget(
                          controller: footerTextController),
                      requiredField: true,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtonWidget(
                isLoading: profileController.isLoading,
                buttonText: 'update'.tr, onPressed: (){
                String shopName = shopNameController.text.trim();
                String email = emailController.text.trim();
                String phone = phoneController.text.trim();
                String address = addressController.text.trim();
                String pagination = paginationTextController.text.trim();
                String footer = footerTextController.text.trim();
                String stockLimit = stockLimitController.text.trim();
                String vatReg = vatRegistrationNoController.text.trim();
                BusinessInfo shop = BusinessInfo(
                  paginationLimit: pagination,
                  currency:  currency,
                  shopName: shopName,
                  shopAddress: address,
                  shopEmail: email,
                  shopPhone: phone,
                  stockLimit: stockLimit,
                  timeZone: profileController.selectedTimeZone,
                  country: countryIsoCode,
                  footerText: footer,
                  vat: vatReg
                );
                if(int.parse(pagination)<1){
                  showCustomSnackBarHelper('pagination_should_be_greater_than_0'.tr);
                }else{
                  profileController.updateShop(shop).then((value){
                    splashController.getConfigData();
                  });
                }

              },),
            ),
          ],
        );
      }
    );
  }
}
// Widget _buildDropdownItemForCountry(Country country) => SizedBox(
//     width: MediaQuery.of(Get.context!).size.width-85,
//     child: Text("${country.name}"));




class BuildDropdownItem extends StatelessWidget {
  final Country country;
  final bool isCountry;
  const BuildDropdownItem({Key? key, required this.country, required this.isCountry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(Get.context!).size.width-85,
      child: Text("${isCountry ?  country.name : country.currencyCode}"),
    );
  }
}
