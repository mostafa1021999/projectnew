import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:six_pos/common/controllers/cart_controller.dart';
import 'package:six_pos/features/pos/domain/enums/amount_type_enum.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/account_management/controllers/transaction_controller.dart';
import 'package:six_pos/common/models/place_order_model.dart';
import 'package:six_pos/common/models/cart_model.dart';
import 'package:six_pos/common/models/temporary_cart_list_model.dart' as customer;
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/helper/animated_custom_dialog_helper.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_divider.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:six_pos/features/pos/widgets/item_price_widget.dart';
import 'package:six_pos/features/pos/widgets/confirm_purchase_dialog_widget.dart';
import 'package:six_pos/features/pos/widgets/coupon_dialog_widget.dart';
import 'package:six_pos/features/pos/widgets/customer_search_dialog_widget.dart';
import 'package:six_pos/features/pos/widgets/extra_discount_dialog_widget.dart';
import 'package:six_pos/features/pos/widgets/item_card_widget.dart';
import 'package:six_pos/features/user/screens/add_new_user_screen.dart';

import '../../../util/app_constants.dart';
import '../../dashboard/controllers/menu_controller.dart';
import '../../dashboard/domain/tab_type_enum.dart';
import '../../shop/controllers/profile_controller.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../splash/controllers/splash_controller.dart';



var rng = Random();
int ?taxNumber;
double subTotal = 0,
    productDiscount = 0,
    total = 0,
    payable = 0,
    couponAmount = 0,
    extraDiscount = 0,
    productTax = 0,
    orderWithoutVat = 0,
    xxDiscount = 0;
bool removeVat = false;
int accountIndex=0;
class PosScreen extends StatefulWidget {
  final bool fromMenu;
  const PosScreen({Key? key, this.fromMenu = false}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final ScrollController _scrollController = ScrollController();


  int userId = 0;
  String customerName = '';
  String customerId = '0';
  TextEditingController moneyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateTaxNumber();
    final CartController cartController = Get.find<CartController>();
    cartController.collectedCashController.text = '0';
    cartController.extraDiscountController.text = '0';

    cartController.setReturnAmountToZero(isUpdate: false);
    Get
        .find<TransactionController>()
        .setFromAccountIndex = null;
    Get
        .find<TransactionController>()
        .setSelectedFromAccountId = null;
  }
  void generateTaxNumber() {
    if(taxNumber==null){
    var rng = Random();
    taxNumber = rng.nextInt(10000000); }// Generate a random tax number
  }

  Future<void> uploadPdf(File file, email) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppConstants.baseUrl}${AppConstants.uploadReceiptUri}'),
    );

    // Add the email field
    request.fields['email'] = email;

    // Attach the PDF file to the request
    request.files.add(
      http.MultipartFile(
        'pdf', // The name of the field expected by the API for the PDF file
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: file.path.split('/').last,
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('File uploaded successfully!');
      } else if (response.statusCode == 302) {
        final location = response.headers['location'];
        print('Redirected to: $location');
        // Handle redirection if necessary
      } else {
        print('File upload failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void _onSubmit()async {
    final CartController cartController = Get.find<CartController>();
    final ProfileController profileModel = Get.find<ProfileController>();
    final TransactionController transactionController = Get.find<
        TransactionController>();
    if (cartController.customerCartList.isEmpty ||
        cartController.customerCartList[Get
            .find<CartController>()
            .customerIndex].cart!.isEmpty) {
      showCustomSnackBarHelper('please_select_at_least_one_product'.tr);
    } else if (transactionController.selectedFromAccountId == null) {
      showCustomSnackBarHelper('select_payment_method'.tr);
    } else if (transactionController.selectedFromAccountId == 1 &&
        cartController.collectedCashController.text
            .trim()
            .isEmpty) {
      showCustomSnackBarHelper('please_pay_first'.tr);
    }else if (transactionController.selectedFromAccountId == 1 &&
        double.parse(cartController.collectedCashController.text.trim()) <
            (removeVat ? total - productTax : total)) {
      showCustomSnackBarHelper('please_pay_full_amount'.tr);
    }else if(checklist[2] == true&&Get.find<CartController>().customerSelectedEmail==''){
      showCustomSnackBarHelper('choose_customer'.tr);
    } else {
      final SplashController splashController = Get.find<SplashController>();
      double? amount = double.tryParse(cartController.collectedCashController.text.trim());
      final DateTime now = DateTime.now();
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      final String formattedDate = dateFormatter.format(now);
      final qrCode=await generateQrCodeImageZACTA(
        splashController.configModel!.businessInfo!.shopName??'',
        splashController.configModel!.businessInfo!.vat??'',
        formattedDate,
        removeVat? '${double.parse(subTotal.toStringAsFixed(2))}':'${double.parse(total.toStringAsFixed(2))}',
        removeVat? '0.00':'${double.parse(productTax.toStringAsFixed(2))}',
      );
      showAnimatedDialogHelper(context,
          ConfirmPurchaseDialogWidget(
              onYesPressed: cartController.isLoading ? null : () {
                List<Cart> carts = [];
                productDiscount = 0;
                productTax = 0;
                for (int index = 0; index <
                    cartController.customerCartList[cartController
                        .customerIndex].cart!.length; index++) {
                  CartModel cart = cartController
                      .customerCartList[cartController.customerIndex]
                      .cart![index];
                  carts.add(Cart(
                    cart.product!.id.toString(),
                    cart.price.toString(),
                    cart.product!.discountType == 'amount'
                        ?
                    productDiscount + cart.product!.discount!
                        : productDiscount + ((cart.product!.discount! / 100) *
                        cart.product!.sellingPrice!),
                    cart.quantity,
                    removeVat? 0:productTax + ((cart.product!.tax! / 100) *
                        cart.product!.sellingPrice!),
                    cart.product?.title ?? 'Unknown Product',
                  ));
                }
                PlaceOrderModel placeOrderBody = PlaceOrderModel(
                  cart: carts,
                  qrCode: '${qrCode['qrKey']}',
                  couponDiscountAmount: cartController.couponCodeAmount,
                  couponCode: cartController.coupons?.couponCode,
                  orderAmount: cartController.amount,
                  userId: cartController.customerId,
                  collectedCash: transactionController.selectedFromAccountId ==
                      0 ? double.parse(
                      cartController.customerWalletController.text.trim()) :
                  transactionController.selectedFromAccountId == 1
                      ? double.parse(
                      cartController.collectedCashController.text.trim())
                      : 0.0,
                  extraDiscountType: cartController.selectedDiscountType,
                  extraDiscount: cartController.extraDiscountController.text
                      .trim()
                      .isEmpty ? 0.0 : double.parse(
                      PriceConverterHelper.discountCalculationWithOutSymbol(
                          context, subTotal, cartController.extraDiscountAmount,
                          cartController.selectedDiscountType)),
                  returnedAmount: cartController.returnToCustomerAmount,
                  type: Get
                      .find<TransactionController>()
                      .selectedFromAccountId,
                  transactionRef: transactionController.selectedFromAccountId !=
                      0 && transactionController.selectedFromAccountId != 1
                      ? cartController.collectedCashController.text.trim()
                      : '',
                );
                cartController.placeOrder(placeOrderBody).then((value) async{
                  final finalPdfFile =await PdfGenerator().generateFinalPdf(value.body['order_id'],placeOrderBody,qrCode['qrImage']);
                  if (value.isOk) {
                    if (amount != null) {

                      if (checklist[2] == true) {
                        try {
                            await uploadPdf(finalPdfFile, Get.find<CartController>().customerSelectedEmail);
                        } catch (e) {
                          print('Error: $e');
                        }
                      }
                    }
                    removeVat=false;
                    taxNumber=null;
                    couponAmount = 0;
                    extraDiscount = 0;
                    Get.find<ProductController>().getLimitedStockProductList(1);
                  }
                });

              },
          ),
          dismissible: false,
          isFlip: false);
      print('checklist[2]: ${checklist[2]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    customerId = Get
        .find<CartController>()
        .customerId
        .toString();


    return GestureDetector(
      onTap: () => Get.find<CartController>().setSearchCustomerList(null),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: widget.fromMenu ? const CustomAppBarWidget() : null,
        body: RefreshIndicator(
          color: Theme
              .of(context)
              .cardColor,
          backgroundColor: Theme
              .of(context)
              .primaryColor,
          onRefresh: () async {},
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: GetBuilder<CartController>(
                  builder: (cartController) {
                    productDiscount = _getAmount(
                        cartController.customerCartList,
                        cartController.customerIndex, AmountType.discount);
                    total = 0;
                    productTax = _getAmount(cartController.customerCartList,
                        cartController.customerIndex, AmountType.tax);
                    subTotal = cartController.amount;

                    if (cartController.customerCartList.isNotEmpty) {
                      couponAmount =
                          cartController.customerCartList[cartController
                              .customerIndex].couponAmount ?? 0;
                      xxDiscount =
                          cartController.customerCartList[cartController
                              .customerIndex].extraDiscount ?? 0;
                      xxDiscount =
                          cartController.customerCartList[cartController
                              .customerIndex].extraDiscount ?? 0;
                    } else {
                      subTotal = 0;
                      productDiscount = 0;
                      total = 0;
                      payable = 0;
                      couponAmount = 0;
                      extraDiscount = 0;
                      productTax = 0;
                      xxDiscount = 0;
                    }


                    extraDiscount = double.parse(
                        PriceConverterHelper.discountCalculationWithOutSymbol(
                            context, subTotal, xxDiscount,
                            cartController.selectedDiscountType));
                    total = subTotal - productDiscount - couponAmount -
                        extraDiscount + productTax;
                    payable = total;


                    return Column(children: [
                      CustomHeaderWidget(title: 'billing_section'.tr,
                          headerImage: Images.billingSection),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      GetBuilder<CartController>(builder: (customerController) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(
                              Dimensions.paddingSizeDefault, 0,
                              Dimensions.paddingSizeDefault, 0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextFieldWidget(
                                      hintText: 'search_customer'.tr,
                                      onChanged: (value) {
                                        customerController.onSearchCustomer(
                                            value);
                                      },
                                      suffixIcon: Images.searchIcon,
                                      suffix: true,
                                    ),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeSmall),

                                    Stack(children: [
                                      Column(children: [
                                        CustomButtonWidget(
                                          buttonText: 'add_customer'.tr,
                                          buttonColor: Theme
                                              .of(context)
                                              .secondaryHeaderColor,
                                          onPressed: () => Get.to(() =>
                                          const AddNewUserScreen(
                                              isCustomer: true)),
                                        ),

                                        const SizedBox(height: Dimensions
                                            .paddingSizeSmall),

                                        CustomButtonWidget(
                                          buttonText: 'new_order'.tr,
                                          onPressed: () {
                                            bool isW = cartController
                                                .searchCustomerController
                                                .text == 'walking customer';
                                            customerId =
                                            isW ? '0' : cartController
                                                .customerId.toString();
                                            customer
                                                .TemporaryCartListModel customerCart = customer
                                                .TemporaryCartListModel(
                                              cart: [],
                                              userIndex: customerId != '0' ? int
                                                  .parse(customerId) : taxNumber,
                                              userId: customerId != '0' ? int
                                                  .parse(customerId) : int
                                                  .parse(customerId),
                                              customerName: customerId == '0'
                                                  ? '$taxNumber'
                                                  : '${customerController
                                                  .customerSelectedName} ${customerController
                                                  .customerSelectedMobile}',
                                              customerBalance: customerController
                                                  .customerBalance,
                                            );
                                            Get.find<CartController>()
                                                .addToCartListForUser(
                                                customerCart, clear: true,
                                                payable: payable);
                                            cartController
                                                .collectedCashController
                                                .clear();
                                          },),

                                      ]),
                                      const CustomerSearchDialogWidget(),
                                    ]),


                                  ],)),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Expanded(child: Column(children: [
                                  Text('${'current_customer_status'.tr} :',
                                    style: fontSizeRegular.copyWith(
                                        fontSize: Dimensions.fontSizeSmall),),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Dimensions
                                            .paddingSizeExtraSmall),
                                    child: Text(customerController
                                        .customerSelectedName ?? '',
                                      style: fontSizeMedium.copyWith(
                                          color: Theme
                                              .of(context)
                                              .secondaryHeaderColor),),
                                  ),


                                  Text(customerController
                                      .customerSelectedMobile != 'NULL'
                                      ? customerController
                                      .customerSelectedMobile ?? ''
                                      : '',
                                    style: fontSizeMedium.copyWith(
                                        color: Theme
                                            .of(context)
                                            .secondaryHeaderColor),),



                                  const SizedBox(height: Dimensions
                                      .paddingSizeCustomBottom),
                                  CustomButtonWidget(
                                      buttonText: 'clear_all_cart'.tr,
                                      textColor: Theme
                                          .of(context)
                                          .primaryColor,
                                      isClear: true,
                                      buttonColor: Theme
                                          .of(context)
                                          .hintColor,
                                      onPressed: () {
                                        Get.find<CartController>()
                                            .removeAllCartList();
                                      }),
                                ],)),
                              ]),
                        );
                      }),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                      GetBuilder<BottomManuController>(builder: (
                          menuController) =>
                          GetBuilder<ProfileController>(
                            builder: (profileController) =>
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15),
                                  child: CustomButtonWidget(
                                    buttonText: 'add_product'.tr,
                                    onPressed: () {
                                      menuController.onChangeMenu(
                                          type: NavbarType.items);
                                    },
                                  ),
                                ),
                          ),
                      ),
                      GetBuilder<CartController>(builder: (
                          customerCartController) {
                        return customerCartController.customerCartList
                            .isNotEmpty ? Padding(
                          padding: const EdgeInsets.fromLTRB(
                              Dimensions.paddingSizeDefault, 0,
                              Dimensions.paddingSizeDefault, 0),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(color: Theme
                                .of(context)
                                .cardColor,
                                border: Border.all(width: .5, color: Theme
                                    .of(context)
                                    .hintColor
                                    .withOpacity(.7)),
                                borderRadius: BorderRadius.circular(
                                    Dimensions.paddingSizeMediumBorder)),
                            child: DropdownButton<int>(
                              hint: Text('select'.tr),
                              value: customerCartController
                                  .customerIds[cartController.customerIndex],
                              items: customerCartController.customerIds.map((
                                  int? value) {
                                return DropdownMenuItem<int>(
                                    value: value,
                                    child: Text(customerCartController
                                        .customerCartList[(customerCartController
                                        .customerIds.indexOf(value))]
                                        .customerName ?? '',
                                        style: fontSizeRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall))
                                );
                              }).toList(),
                              onChanged: (int? value) async {
                                if (value != null) {
                                  cartController.onChangeOrder(value, payable);
                                }
                                cartController.collectedCashController.clear();
                                cartController.setReturnAmountToZero();
                              },
                              isExpanded: true,
                              underline: const SizedBox(),),),
                        ) : const SizedBox();
                      }),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Container(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.paddingSizeDefault, 0,
                            Dimensions.paddingSizeDefault, 0),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .primaryColor
                              .withOpacity(.06),
                        ),
                        child: Row(children: [

                          Expanded(flex: 6, child: Text('item_info'.tr)),

                          Expanded(flex: 2, child: Text('qty'.tr)),

                          Expanded(flex: 1, child: Text('price'.tr)),

                        ]),
                      ),

                      cartController.customerCartList.isNotEmpty ? GetBuilder<
                          CartController>(builder: (custController) {
                        return ListView.builder(
                          itemCount: cartController
                              .customerCartList[custController.customerIndex]
                              .cart!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (itemContext, index) {
                            return ItemCartWidget(
                              cartModel: cartController
                                  .customerCartList[custController
                                  .customerIndex].cart![index],
                              index: index,
                            );
                          },
                        );
                      }) : const SizedBox(),


                      Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.fontSizeDefault),
                            child: Row(children: [

                              Expanded(child: Text(
                                'bill_summery'.tr,
                                style: fontSizeMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge),
                              )),

                              SizedBox(width: 120,
                                  height: 40,
                                  child: CustomButtonWidget(
                                    buttonText: 'edit_discount'.tr,
                                    onPressed: () =>
                                        showAnimatedDialogHelper(
                                          context, ExtraDiscountDialogWidget(
                                            totalAmount: total,
                                            isBank: false,
                                            sendReceipt: false),
                                          dismissible: false, isFlip: false,
                                        ),
                                  )),

                            ]),
                          ),
                          ItemPriceWidget(title: 'subtotal'.tr,
                              amount: PriceConverterHelper.priceWithSymbol(
                                  subTotal)),

                          ItemPriceWidget(title: 'product_discount'.tr,
                              amount: PriceConverterHelper.priceWithSymbol(
                                  productDiscount)),

                          ItemPriceWidget(title: 'coupon_discount'.tr,
                            total: () {
                              cartController.removeCouponDiscount(
                                cartController.couponController.text.trim(),
                                cartController.customerId,
                                cartController.amount,
                              );
                            }
                            ,
                            amount: PriceConverterHelper.priceWithSymbol(
                                couponAmount),
                            isCoupon: true,
                            onTap: () {
                              showAnimatedDialogHelper(context,
                                  const CouponDialogWidget(),
                                  dismissible: false,
                                  isFlip: false);
                            },),

                          ItemPriceWidget(
                              title: 'extra_discount'.tr, total: () {
                            cartController.removeCouponCodeAndExtraDiscount(
                                total);
                          }, amount: PriceConverterHelper.convertPrice(
                              context,
                              PriceConverterHelper.discountCalculation(context,
                                subTotal,
                                cartController.extraDiscountAmount,
                                cartController.selectedDiscountType,
                              ))),

                          ItemPriceWidget(title: 'vat'.tr,
                            amount:removeVat?PriceConverterHelper.priceWithSymbol(0): PriceConverterHelper.priceWithSymbol(
                                productTax),
                            total: (){
                            setState(() {
                              removeVat=true;
                            });

                            },),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault),
                            child: CustomDividerWidget(height: .4, color: Theme
                                .of(context)
                                .hintColor
                                .withOpacity(1),),
                          ),

                          ItemPriceWidget(title: 'total'.tr,
                              amount:removeVat?PriceConverterHelper.priceWithSymbol(
                                  total-productTax)  :PriceConverterHelper.priceWithSymbol(
                                  total),
                              total: total,
                              isTotal: true),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                Dimensions.paddingSizeDefault,
                                Dimensions.paddingSizeExtraSmall,
                                Dimensions.paddingSizeDefault,
                                Dimensions.paddingSizeExtraSmall),
                            child: Text('payment_via'.tr,
                              style: fontSizeRegular.copyWith(color: Theme
                                  .of(context)
                                  .hintColor),),
                          ),


                          GetBuilder<TransactionController>(
                              builder: (accountController) {
                                return Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      Dimensions.paddingSizeDefault, 0,
                                      Dimensions.paddingSizeDefault, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start, children: [
                                    Container(
                                      height: 50,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Dimensions
                                              .paddingSizeSmall),
                                      decoration: BoxDecoration(color: Theme
                                          .of(context)
                                          .cardColor,
                                          border: Border.all(
                                              width: .5, color: Theme
                                              .of(context)
                                              .hintColor
                                              .withOpacity(.7)),
                                          borderRadius: BorderRadius.circular(
                                              Dimensions
                                                  .paddingSizeMediumBorder)),
                                      child: DropdownButton<int>(
                                        hint: Text('select'.tr),
                                        value: accountController
                                            .fromAccountIndex,
                                        items: accountController.fromAccountIds
                                            ?.map((int? value) {
                                          return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(
                                                  accountController
                                                      .accountList![(accountController
                                                      .fromAccountIds!.indexOf(
                                                      value))].account!));
                                        }).toList(),
                                        onChanged: (int? value) {
                                          accountIndex=accountController.fromAccountIds!.indexOf(value);
                                          if (value == 1 || value == 4) {
                                            FocusScope.of(context).requestFocus(
                                                _textFieldFocusNode);
                                          }
                                          if (value == 2) {
                                            showAnimatedDialogHelper(
                                              context,
                                              ExtraDiscountDialogWidget(
                                                  totalAmount: total,
                                                  isBank: true,
                                                  sendReceipt: false),
                                              dismissible: false, isFlip: false,
                                            );
                                          }
                                          accountController.setAccountIndex(
                                              value, 'from', true);
                                          cartController.collectedCashController
                                              .clear();
                                          cartController.getReturnAmount(
                                            removeVat? payable-productTax:payable,);
                                        },
                                        isExpanded: true,
                                        underline: const SizedBox(),),),
                                    const SizedBox(
                                        height: Dimensions.paddingSizeSmall),
                                  ],),
                                );
                              }
                          ),

                          GetBuilder<TransactionController>(
                              builder: (transactionController) {
                                return Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      Dimensions.paddingSizeDefault,
                                      Dimensions.paddingSizeExtraSmall,
                                      Dimensions.paddingSizeDefault,
                                      Dimensions.paddingSizeExtraSmall),
                                  child: Row(children: [
                                    Expanded(
                                      child: Text(transactionController
                                          .selectedFromAccountId == 0
                                          ? 'customer_balance'.tr
                                          :
                                      transactionController
                                          .selectedFromAccountId == 1
                                          ? 'collected_cash'.tr
                                          : 'transaction_reference'.tr,
                                          style: fontSizeRegular.copyWith(
                                              color: Theme
                                                  .of(context)
                                                  .secondaryHeaderColor)),
                                    ),

                                    transactionController
                                        .selectedFromAccountId == 0
                                        ? const SizedBox()
                                        : Icon(Icons.edit, color: Theme
                                        .of(context)
                                        .primaryColor),
                                    GetBuilder<CartController>(
                                        builder: (customerController) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: transactionController
                                                      .selectedFromAccountId ==
                                                      0 ? Theme
                                                      .of(context)
                                                      .hintColor :
                                                  Theme
                                                      .of(context)
                                                      .secondaryHeaderColor,
                                                  width: transactionController
                                                      .selectedFromAccountId ==
                                                      0 ? 0 : 1),
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                  .paddingSizeMediumBorder),
                                            ),
                                            child: SizedBox(width: 150,
                                              child: CustomTextFieldWidget(
                                                hintText: 'balance_hint'.tr,
                                                isEnabled: transactionController
                                                    .selectedFromAccountId ==
                                                    0 && Get
                                                    .find<CartController>()
                                                    .customerId != 0
                                                    ? false
                                                    : true,
                                                controller: transactionController
                                                    .selectedFromAccountId ==
                                                    0 && Get
                                                    .find<CartController>()
                                                    .customerId != 0
                                                    ? cartController
                                                    .customerWalletController
                                                    : cartController
                                                    .collectedCashController,
                                                inputType: TextInputType.number,
                                                onChanged: (value) {
                                                  if (transactionController
                                                      .selectedFromAccountId ==
                                                      1) {
                                                    cartController
                                                        .getReturnAmount(
                                                        removeVat? payable-productTax:payable);
                                                  }
                                                },
                                                focusNode: _textFieldFocusNode,
                                              ),
                                            ),);
                                        }
                                    )
                                  ],),
                                );
                              }
                          ),
                          GetBuilder<TransactionController>(
                              builder: (transactionController) {
                                return transactionController
                                    .selectedFromAccountId == 0 ||
                                    transactionController
                                        .selectedFromAccountId == 1 ? Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      Dimensions.paddingSizeDefault, 0,
                                      Dimensions.paddingSizeDefault,
                                      Dimensions.paddingSizeExtraSmall),
                                  child: Row(children: [
                                    Text(transactionController
                                        .selectedFromAccountId == 0 && Get
                                        .find<CartController>()
                                        .customerId != 0 ? 'remaining_balance'
                                        .tr :
                                    transactionController
                                        .selectedFromAccountId == 1
                                        ? 'returned_amount'.tr
                                        : '', style: fontSizeRegular.copyWith(
                                        color: Theme
                                            .of(context)
                                            .secondaryHeaderColor)),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: Dimensions
                                              .paddingSizeSmall,
                                          vertical: Dimensions
                                              .paddingSizeExtraSmall),
                                      child: Text(
                                          PriceConverterHelper.priceWithSymbol(
                                              cartController.returnToCustomerAmount ?? 0),
                                          style: fontSizeRegular.copyWith(
                                              color: Theme
                                                  .of(context)
                                                  .secondaryHeaderColor)),
                                    )
                                  ],),
                                ) : const SizedBox();
                              }
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Dimensions.paddingSizeDefault,
                                vertical: Dimensions.paddingSizeDefault),
                            child: CustomDividerWidget(height: .4, color: Theme
                                .of(context)
                                .hintColor
                                .withOpacity(1),),
                          ),

                          GetBuilder<TransactionController>(
                              builder: (transactionController) {
                                return Container(
                                  padding: const EdgeInsets.fromLTRB(
                                    Dimensions.paddingSizeDefault, 0,
                                    Dimensions.paddingSizeDefault,
                                    Dimensions.paddingSizeExtraSmall,
                                  ),
                                  height: 50,
                                  child: Row(children: [
                                    Expanded(child: CustomButtonWidget(
                                      buttonText: 'cancel'.tr,
                                      isClear: true,
                                      textColor: Theme
                                          .of(context)
                                          .primaryColor,
                                      buttonColor: Theme
                                          .of(context)
                                          .hintColor,
                                      onPressed: () {
                                        subTotal = 0;
                                        productDiscount = 0;
                                        total = 0;
                                        payable = 0;
                                        couponAmount = 0;
                                        extraDiscount = 0;
                                        productTax = 0;
                                        taxNumber=null;
                                        removeVat=false;
                                        cartController.customerCartList[Get
                                            .find<CartController>()
                                            .customerIndex].cart!.clear();
                                        cartController.removeAllCart();
                                        cartController.setReturnAmountToZero();
                                      },
                                    )),
                                    const SizedBox(
                                      width: Dimensions.paddingSizeSmall,),

                                    Expanded(child: CustomButtonWidget(
                                      buttonText: 'place_order'.tr,
                                      onPressed: () => _onSubmit(),
                                    )),
                                  ]),
                                );
                              }),
                          GetBuilder<BottomManuController>(
                            builder: (menuController) =>
                                GetBuilder<ProfileController>(
                                  builder: (profileController) =>
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15),
                                        child: CustomButtonWidget(
                                          buttonText: 'send_receipt'.tr,
                                          onPressed: () {
                                            showAnimatedDialogHelper(
                                              context,
                                              ExtraDiscountDialogWidget(
                                                  totalAmount: total,
                                                  isBank: true,
                                                  sendReceipt: true),
                                              dismissible: false, isFlip: false,
                                            );
                                          },
                                        ),
                                      ),
                                ),
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeRevenueBottom,),
                        ],),
                    ],);
                  }
              ))
            ],
          ),
        ),
      ),
    );
  }


  double _getAmount(List<customer.TemporaryCartListModel>? customerCartList,
      int customerIndex, AmountType amountType) {
    double amount = 0;
    if ((customerCartList?.isNotEmpty ?? false)) {
      if (amountType == AmountType.discount) {
        for (int i = 0; i <
            (customerCartList?[customerIndex].cart?.length ?? 0); i++) {
          if (customerCartList?[customerIndex].cart?[i].product?.discountType ==
              'amount') {
            amount = amount +
                customerCartList![customerIndex].cart![i].product!.discount! *
                    customerCartList[customerIndex].cart![i].quantity!;
          } else
          if (customerCartList?[customerIndex].cart?[i].product?.discountType ==
              'percent') {
            amount = amount +
                (customerCartList![customerIndex].cart![i].product!.discount! /
                    100) * customerCartList[customerIndex].cart![i].product!
                    .sellingPrice! *
                    customerCartList[customerIndex].cart![i].quantity!;
          }
        }
      } else if (amountType == AmountType.tax) {
        if ((customerCartList?.isNotEmpty ?? false)) {
          for (int i = 0; i <
              (customerCartList?[customerIndex].cart?.length ?? 0); i++) {
            amount = amount +
                (customerCartList![customerIndex].cart![i].product!.tax! / 100
                ) * customerCartList[customerIndex].cart![i].product!
                    .sellingPrice! *
                    customerCartList[customerIndex].cart![i].quantity!;
          }
        }
      }
    }

    return amount;
  }
}


int selectedPaymentMethod = 1;
final _textFieldFocusNode = FocusNode();

Widget bottomRemove()=>CircleAvatar(
  radius: 14,
  backgroundColor: Colors.red,
  child: Icon(Icons.close,color: Colors.white,),
);


class PdfGenerator {
  static late pw.Font arFont;

  // Initialize the font
  static Future<void> init() async {
    try {
      arFont = arFont = pw.Font.ttf(await rootBundle.load("assets/font/arabic/Cairo-SemiBold.ttf"));
    } catch (e) {
      print('Error loading font: $e');
    }
  }

  // Generate the final PDF
  Future<File> generateFinalPdf(invoice,PlaceOrderModel placeOrderModel,pw.ImageProvider qrImage) async {
    final pdf = pw.Document();
    final SplashController splashController = Get.find<SplashController>();
    final ProfileController profileController = Get.find<ProfileController>();
    final DateTime now = DateTime.now();
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    final String formattedDate = dateFormatter.format(now);
    final ByteData imageData = await rootBundle.load(Images.splashLogo); // Update path as necessary
    final Uint8List imageBytes = imageData.buffer.asUint8List();
    final pw.ImageProvider image = pw.MemoryImage(imageBytes);
    final PdfPageFormat pdfPageFormat = PdfPageFormat(135 * PdfPageFormat.mm, 297 * PdfPageFormat.mm);

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.all(10),
        pageFormat: pdfPageFormat,
        build: (pw.Context context) {
          final carts = placeOrderModel.cart ?? [];
          return<pw.Widget>[ pw.Container(
                      decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColors.black,
            width: 2,
          ),
                      ),
                      child: pw.Padding(
          padding: const pw.EdgeInsets.all(10),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Image(image, width: 100),
              ),
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'فاتورة ضريبيه مبسطة',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        font: arFont,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.Text(
                      'Simplified Tax Invoice',
                      style: pw.TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    pw.Text(
                      'شركة استاكس',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        font: arFont,
                      ),
                      textDirection: pw.TextDirection.rtl,
                    ),
                    pw.Text(
                      'Stax company',
                      style: pw.TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    pw.Text(
                      '${splashController.configModel!.businessInfo!.shopAddress}',
                      style: pw.TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Column(
                children: [
                  _buildColumnWithTitle('الرقم التعريفى الضريبى', 'VAT Number', arFont, '${splashController.configModel!.businessInfo!.vat}'),
                  _buildColumnWithTitle('رقم الفاتورة', 'Invoice Number', arFont, '$invoice'),
                  _buildColumnWithTitle('تاريخ الفاتورة', 'Invoice Date', arFont, formattedDate),
                  _buildColumnWithTitle('نوع الدفع', 'Payment type', arFont,'${Get.find<TransactionController>().accountList![accountIndex].account}'),
                  _buildColumnWithTitle('الموظف', 'Employee', arFont, '${profileController.profileModel!.id}, ${profileController.profileModel!.fName} ${profileController.profileModel!.lName}'),
                ],
              ),
              pw.Divider(),
              pw.Text(
                'تفاصيل الفاتورة',
                style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    font: arFont
                ),
                textDirection: pw.TextDirection.rtl,
              ),
              pw.Text(
                'Details',
                style: pw.TextStyle(
                  fontSize:  11,
                ),
              ),
              pw.Table.fromTextArray(
                cellAlignment:pw.Alignment.center,
                headers: [
                  topTable('اسم المنتج', 'Product name'),topTable('خصم', 'Discount') , topTable('كميه', 'Quantity'), topTable('الاجمالى شامل الضريبه', 'Total VAT Inclusive')],
                data: carts.map((cart) {
                  final productName =  cart.productName ?? 'Unknown Product'; // Use the product name
                  final discount = cart.discountAmount ?? 0;
                  final tax = cart.taxAmount ?? 0;
                  final price = double.parse(cart.price ?? '0');
                  final quantity = cart.quantity ?? 0;
                  final totalPrice =removeVat? (price - discount) * quantity:(price - discount+tax) * quantity;

                  return [
                    pw.Text(productName, style: pw.TextStyle(font: arFont,fontSize: 11),textDirection: pw.TextDirection.rtl,),// Use the product name
                    pw.Text(discount.toStringAsFixed(2), style: pw.TextStyle(fontSize: 11),),// Use the product name
                    pw.Text(quantity.toString(), style: pw.TextStyle(fontSize: 11),),
                    pw.Text(totalPrice.toStringAsFixed(2), style: pw.TextStyle(fontSize: 11),),
                  ];
                }).toList(),
              ),
              pw.Divider(),
              _itemPriceWidget('الاجمالى شامل الضريبه','Total Vat Inclusive', removeVat ? '${total - productTax} Sar' : '$total Sar', arFont, ),
              _itemPriceWidget('معدل ضريبه القيمة المضافة','VAT', '15.0%', arFont, ),
              _itemPriceWidget('اجمالى ضريبه القيمة المضافة المجمعه','Total VAT Collected', removeVat ? '0.0 Sar' : '$productTax Sar', arFont, ),
              pw.Divider(),
              pw.Center(
              child:pw.Column(children: [
                pw.Text(
                  'رمز الاستجابه السريع',
                  style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      font: arFont
                  ),
                  textDirection: pw.TextDirection.rtl,
                ),
                pw.Text(
                  'QR Code',
                  style: pw.TextStyle(
                    fontSize: 11,
                  ),
                ),
                pw.Image(qrImage, width: 100, height: 100),
              ]))

            ],
          ),
                      ),
                    )];
        },
      ),
    );

    // Save the final PDF to a file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/final_example.pdf");
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  pw.Widget _itemPriceWidget(String titleAr,String titleEn, String price, pw.Font font, {bool isTotal = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
          pw.Text(
            titleAr,
            style: pw.TextStyle(
                fontSize: 11,
                fontWeight: pw.FontWeight.bold,
                font: arFont
            ),
            textDirection: pw.TextDirection.rtl,
          ),
          pw.Text(
            titleEn,
            style: pw.TextStyle(
              fontSize: isTotal ? 13 : 11,
              fontWeight: pw.FontWeight.bold,
              font: font,
            ),
          ),
        ]),
        pw.Text(
          price,
          style: pw.TextStyle(
            fontSize: isTotal ? 13 : 11,
            fontWeight: pw.FontWeight.bold,
            font: font,
          ),
        ),
      ],
    );
  }
  pw.Widget topTable(nameAr,nameEn){return pw.Column(children: [pw.Text('$nameAr', style: pw.TextStyle(font: arFont,fontSize: 10),textDirection: pw.TextDirection.rtl,),pw.Text('$nameEn', style: pw.TextStyle(fontSize: 10))]);}
  pw.Widget _buildColumnWithTitle(String title, String subtitle, pw.Font font, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            font: font,
          ),
          textDirection: pw.TextDirection.rtl,
        ),
        pw.Text(
          subtitle,
          style: pw.TextStyle(
            fontSize: 11,
          ),
        ),]),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 11,
            font: font,
          ),
          textDirection: pw.TextDirection.rtl,
        ),
      ],
    );
  }
}
Future<pw.MemoryImage> generateQrCodeImage(String url) async {
  final qrValidationResult = QrValidator.validate(
    data: url,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.L,
  );

  if (qrValidationResult.status != QrValidationStatus.valid) {
    throw Exception('Failed to validate QR code');
  }

  final qrCode = qrValidationResult.qrCode!;
  final painter = QrPainter.withQr(
    qr: qrCode,
    color: const Color(0xFF000000),
    emptyColor: const Color(0xFFFFFFFF),
    gapless: true,
  );

  final picData = await painter.toImageData(150);
  final qrImage = pw.MemoryImage(Uint8List.fromList(picData!.buffer.asUint8List()));

  return qrImage;
}
Future<Map<String, dynamic>> generateQrCodeImageZACTA(
    String sellerName,
    String vatNumber,
    String timestamp,
    String totalAmount,
    String vatAmount
    ) async {
  // Encode the required fields
  final List<int> sellerNameBytes = utf8.encode(sellerName);
  final List<int> vatNumberBytes = utf8.encode(vatNumber);
  final List<int> timestampBytes = utf8.encode(timestamp);
  final List<int> totalAmountBytes = utf8.encode(totalAmount);
  final List<int> vatAmountBytes = utf8.encode(vatAmount);

  final List<int> tlvBytes = [];
  tlvBytes.add(0x01); // Tag for Seller's Name
  tlvBytes.add(sellerNameBytes.length);
  tlvBytes.addAll(sellerNameBytes);

  tlvBytes.add(0x02); // Tag for VAT Registration Number
  tlvBytes.add(vatNumberBytes.length);
  tlvBytes.addAll(vatNumberBytes);

  tlvBytes.add(0x03); // Tag for Timestamp
  tlvBytes.add(timestampBytes.length);
  tlvBytes.addAll(timestampBytes);

  tlvBytes.add(0x04); // Tag for Invoice Total
  tlvBytes.add(totalAmountBytes.length);
  tlvBytes.addAll(totalAmountBytes);

  tlvBytes.add(0x05); // Tag for VAT Total
  tlvBytes.add(vatAmountBytes.length);
  tlvBytes.addAll(vatAmountBytes);

  final String base64QrData = base64Encode(tlvBytes);

  // Generate QR code
  final qrPainter = QrPainter(
    data: base64QrData,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.L,
    color: Colors.black,
    emptyColor: Colors.transparent,
  );

  final ByteData? byteData = await qrPainter.toImageData(200); // Generate image data with size
  if (byteData == null) {
    throw Exception('Failed to generate QR code image data');
  }

  final Uint8List imageBytes = byteData.buffer.asUint8List();

  final pw.MemoryImage qrImage = pw.MemoryImage(imageBytes);

  return {
    'qrKey': base64QrData,
    'qrImage': qrImage,
  };
}
class TaxNumberManager {
  static const String _taxNumberKey = 'taxNumber';

  // Generate a random tax number if it doesn't exist
  static Future<int> generateTaxNumber() async {
    final prefs = await SharedPreferences.getInstance();
    int? taxNumber = prefs.getInt(_taxNumberKey);

    if (taxNumber == null) {
      var rng = Random();
      taxNumber = rng.nextInt(10000000); // Generate a random number
      await prefs.setInt(_taxNumberKey, taxNumber);
    }

    return taxNumber;
  }

  // Retrieve the existing tax number
  static Future<int> getTaxNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_taxNumberKey) ?? await generateTaxNumber();
  }
}