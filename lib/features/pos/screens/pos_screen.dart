import 'package:flutter/material.dart';
import 'package:get/get.dart';
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





class PosScreen extends StatefulWidget {
  final bool fromMenu;
  const PosScreen({Key? key, this.fromMenu = false}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final ScrollController _scrollController = ScrollController();
  double subTotal = 0, productDiscount = 0, total = 0, payable = 0, couponAmount = 0, extraDiscount = 0, productTax = 0, xxDiscount = 0;


  int userId = 0;
  String customerName = '';
  String customerId = '0';

  @override
  void initState() {
    super.initState();

    final CartController cartController = Get.find<CartController>();
    cartController.collectedCashController.text = '0';
    cartController.extraDiscountController.text = '0';
    if(cartController.customerSelectedName == ''){
      cartController.searchCustomerController.text = 'walking customer';
    }
    cartController.setReturnAmountToZero(isUpdate: false);
    Get.find<TransactionController>().setFromAccountIndex = null;
    Get.find<TransactionController>().setSelectedFromAccountId = null;

  }



  @override
  Widget build(BuildContext context) {
    var rng = Random();
    customerId = Get.find<CartController>().customerId.toString();


    return GestureDetector(
      onTap: ()=> Get.find<CartController>().setSearchCustomerList(null),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: widget.fromMenu? const CustomAppBarWidget():null,
        body: RefreshIndicator(
          color: Theme.of(context).cardColor,
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: GetBuilder<CartController>(
                  builder: (cartController) {

                    productDiscount = _getAmount(cartController.customerCartList, cartController.customerIndex, AmountType.discount);
                    total = 0;
                    productTax = _getAmount(cartController.customerCartList, cartController.customerIndex, AmountType.tax);
                    subTotal = cartController.amount;

                    if( cartController.customerCartList.isNotEmpty){
                      couponAmount = cartController.customerCartList[cartController.customerIndex].couponAmount ?? 0;
                      xxDiscount = cartController.customerCartList[cartController.customerIndex].extraDiscount ?? 0;
                    }else{
                      subTotal = 0;
                      productDiscount = 0;
                      total = 0;
                      payable = 0;
                      couponAmount = 0;
                      extraDiscount = 0;
                      productTax = 0;
                      xxDiscount = 0;
                    }


                    extraDiscount =  double.parse(PriceConverterHelper.discountCalculationWithOutSymbol(context, subTotal, xxDiscount, cartController.selectedDiscountType));
                    total = subTotal - productDiscount - couponAmount - extraDiscount + productTax;
                    payable = total;

                    return Column(children: [
                      CustomHeaderWidget(title: 'billing_section'.tr, headerImage: Images.billingSection),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      GetBuilder<CartController>(builder: (customerController) {
                        return Container(
                          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                CustomTextFieldWidget(
                                  hintText: 'search_customer'.tr,
                                  controller: customerController.searchCustomerController,
                                  onChanged: (value){
                                    customerController.onSearchCustomer(value);
                                  },
                                  suffixIcon: Images.searchIcon,
                                  suffix: true,
                                ),
                                const SizedBox(height: Dimensions.paddingSizeSmall),

                                Stack(children: [
                                  Column(children: [
                                    CustomButtonWidget(
                                      buttonText: 'add_customer'.tr,
                                      buttonColor: Theme.of(context).secondaryHeaderColor,
                                      onPressed: ()=> Get.to(()=> const AddNewUserScreen(isCustomer: true)),
                                    ),

                                    const SizedBox(height: Dimensions.paddingSizeSmall),

                                    CustomButtonWidget(buttonText: 'new_order'.tr,
                                      onPressed: (){
                                        bool isW =  cartController.searchCustomerController.text == 'walking customer';
                                        customerId = isW ? '0' : cartController.customerId.toString();
                                        customer.TemporaryCartListModel customerCart = customer.TemporaryCartListModel(
                                          cart: [],
                                          userIndex: customerId != '0' ?  int.parse(customerId) : rng.nextInt(10000),
                                          userId: customerId != '0' ?  int.parse(customerId) : int.parse(customerId),
                                          customerName: customerId == '0'? 'wc-${rng.nextInt(10000)}':'${customerController.customerSelectedName} ${customerController.customerSelectedMobile}',
                                          customerBalance: customerController.customerBalance,
                                        );
                                        Get.find<CartController>().addToCartListForUser(customerCart, clear: true, payable: payable);
                                        cartController.collectedCashController.clear();


                                      },),

                                  ]),


                                  const CustomerSearchDialogWidget(),
                                ]),


                              ],)),
                            const SizedBox(width: Dimensions.paddingSizeSmall),

                            Expanded(child: Column(children: [
                              Text('${'current_customer_status'.tr} :', style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),

                              customerController.customerCartList.isNotEmpty?
                              Column(children: [

                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                  child: Text(customerController.customerSelectedName??'',
                                    style: fontSizeMedium.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                                ),



                                Text(customerController.customerSelectedMobile != 'NULL'? customerController.customerSelectedMobile??'':'',
                                  style: fontSizeMedium.copyWith(color: Theme.of(context).secondaryHeaderColor),),
                              ]):const SizedBox(height: 50),


                              const SizedBox(height: Dimensions.paddingSizeCustomBottom),
                              CustomButtonWidget(buttonText: 'clear_all_cart'.tr,textColor: Theme.of(context).primaryColor,isClear: true,
                                  buttonColor: Theme.of(context).hintColor,
                                  onPressed: (){
                                    Get.find<CartController>().removeAllCartList();
                                  }),
                            ],)),
                          ]),
                        );
                      }),
                      const SizedBox(height: Dimensions.paddingSizeExtraLarge),


                      GetBuilder<CartController>(builder: (customerCartController) {


                        return customerCartController.customerCartList.isNotEmpty ? Padding(
                          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                            child: DropdownButton<int>(
                              hint: Text('select'.tr),
                              value: customerCartController.customerIds[cartController.customerIndex],
                              items: customerCartController.customerIds.map((int? value) {
                                return DropdownMenuItem<int>(
                                    value: value,
                                    child:  Text(customerCartController.customerCartList[(customerCartController.customerIds.indexOf(value))].customerName??'',
                                        style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
                                );
                              }).toList(),
                              onChanged: (int? value) async {
                                if(value != null){
                                  cartController.onChangeOrder(value, payable);
                                }
                                cartController.collectedCashController.clear();
                                cartController.setReturnAmountToZero();
                              },
                              isExpanded: true, underline: const SizedBox(),),),
                        ) : const SizedBox();
                      }),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      Container(
                        padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0, Dimensions.paddingSizeDefault, 0),
                        height: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(.06),
                        ),
                        child: Row(children: [

                          Expanded(flex:6, child: Text('item_info'.tr)),

                          Expanded(flex:2, child: Text('qty'.tr)),

                          Expanded(flex:1, child: Text('price'.tr)),

                        ]),
                      ),

                      cartController.customerCartList.isNotEmpty ? GetBuilder<CartController>(builder: (custController) {
                        return ListView.builder(
                          itemCount: cartController.customerCartList[custController.customerIndex].cart!.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (itemContext, index){
                            return ItemCartWidget(
                              cartModel: cartController.customerCartList[custController.customerIndex].cart![index],
                              index:  index,
                            );
                          },
                        );
                      }) : const SizedBox(),


                      Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeDefault),
                          child: Row(children: [

                            Expanded(child: Text(
                              'bill_summery'.tr,
                              style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                            )),

                            SizedBox(width: 120,height: 40,child: CustomButtonWidget(
                              buttonText: 'edit_discount'.tr,
                              onPressed:() => showAnimatedDialogHelper(
                                context, ExtraDiscountDialogWidget(totalAmount: total),
                                dismissible: false, isFlip: false,
                              ),
                            )),

                          ]),
                        ),
                        ItemPriceWidget(title: 'subtotal'.tr, amount: PriceConverterHelper.priceWithSymbol(subTotal)),

                        ItemPriceWidget(title: 'product_discount'.tr, amount: PriceConverterHelper.priceWithSymbol(productDiscount)),

                        ItemPriceWidget(title: 'coupon_discount'.tr, amount: PriceConverterHelper.priceWithSymbol(couponAmount),isCoupon: true,onTap: (){
                          showAnimatedDialogHelper(context,
                              const CouponDialogWidget(),
                              dismissible: false,
                              isFlip: false);
                        },),

                        ItemPriceWidget(title: 'extra_discount'.tr, amount: PriceConverterHelper.convertPrice(
                            context, PriceConverterHelper.discountCalculation(context,
                          subTotal,
                          cartController.extraDiscountAmount,
                          cartController.selectedDiscountType,
                        ))),

                        ItemPriceWidget(title: 'vat'.tr, amount: PriceConverterHelper.priceWithSymbol(productTax)),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          child: CustomDividerWidget(height: .4,color: Theme.of(context).hintColor.withOpacity(1),),
                        ),

                        ItemPriceWidget(title: 'total'.tr, amount: PriceConverterHelper.priceWithSymbol(total),isTotal: true),

                        Padding(
                          padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeExtraSmall,
                              Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall),
                          child: Text('payment_via'.tr, style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor),),
                        ),


                        GetBuilder<TransactionController>(
                            builder: (accountController) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,Dimensions.paddingSizeDefault,0),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                  Container(
                                    height: 50,
                                    padding: const EdgeInsets.symmetric(horizontal:Dimensions.paddingSizeSmall),
                                    decoration: BoxDecoration(color: Theme.of(context).cardColor,
                                        border: Border.all(width: .5, color: Theme.of(context).hintColor.withOpacity(.7)),
                                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder)),
                                    child: DropdownButton<int>(
                                      hint: Text('select'.tr),
                                      value: accountController.fromAccountIndex,
                                      items: accountController.fromAccountIds?.map((int? value) {
                                        return DropdownMenuItem<int>(
                                            value: value,
                                            child: Text(
                                                accountController.accountList![(accountController.fromAccountIds!.indexOf(value))].account!));}).toList(),
                                      onChanged: (int? value) {
                                        accountController.setAccountIndex(value,'from', true);
                                        cartController.collectedCashController.clear();
                                        cartController.getReturnAmount(payable);
                                      },
                                      isExpanded: true, underline: const SizedBox(),),),
                                  const SizedBox(height: Dimensions.paddingSizeSmall),
                                ],),
                              );
                            }
                        ),

                        GetBuilder<TransactionController>(
                            builder: (transactionController) {
                              return Container(
                                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,Dimensions.paddingSizeExtraSmall,
                                    Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall),
                                child: Row(children: [
                                  Expanded(
                                    child: Text(transactionController.selectedFromAccountId == 0 ? 'customer_balance'.tr :
                                    transactionController.selectedFromAccountId == 1 ?'collected_cash'.tr : 'transaction_reference'.tr,
                                        style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor)),
                                  ),

                                  transactionController.selectedFromAccountId == 0 ? const SizedBox():Icon(Icons.edit, color: Theme.of(context).primaryColor),
                                  GetBuilder<CartController>(
                                      builder: (customerController) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color:transactionController.selectedFromAccountId == 0 ? Theme.of(context).hintColor :
                                            Theme.of(context).secondaryHeaderColor, width: transactionController.selectedFromAccountId == 0 ? 0: 1),
                                            borderRadius: BorderRadius.circular(Dimensions.paddingSizeMediumBorder),
                                          ),
                                          child: SizedBox( width:150,
                                            child: CustomTextFieldWidget(
                                              hintText: 'balance_hint'.tr,
                                              isEnabled: transactionController.selectedFromAccountId == 0 && Get.find<CartController>().customerId !=0? false: true,
                                              controller: transactionController.selectedFromAccountId == 0 && Get.find<CartController>().customerId !=0 ? cartController.customerWalletController : cartController.collectedCashController,
                                              inputType: transactionController.selectedFromAccountId == 1 ?TextInputType.number: TextInputType.text,
                                              onChanged: (value){
                                                if(transactionController.selectedFromAccountId == 1) {
                                                  cartController.getReturnAmount(payable);                                                }
                                              },
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
                              return transactionController.selectedFromAccountId == 0 || transactionController.selectedFromAccountId == 1 ? Container(
                                padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,0,
                                    Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall),
                                child: Row(children: [
                                  Text(transactionController.selectedFromAccountId == 0 && Get.find<CartController>().customerId !=0? 'remaining_balance'.tr :
                                  transactionController.selectedFromAccountId == 1 ?'returned_amount'.tr : '', style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor)),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                                        vertical: Dimensions.paddingSizeExtraSmall),
                                    child: Text(PriceConverterHelper.priceWithSymbol(cartController.returnToCustomerAmount), style: fontSizeRegular.copyWith(color: Theme.of(context).secondaryHeaderColor)),
                                  )
                                ],),
                              ):const SizedBox();
                            }
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                          child: CustomDividerWidget(height: .4,color: Theme.of(context).hintColor.withOpacity(1),),
                        ),

                        GetBuilder<TransactionController>(builder: (transactionController) {
                          return Container(
                            padding: const EdgeInsets.fromLTRB(
                              Dimensions.paddingSizeDefault, 0,
                              Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraSmall,
                            ),
                            height: 50,
                            child: Row(children: [
                              Expanded(child: CustomButtonWidget(
                                buttonText: 'cancel'.tr,isClear: true,
                                textColor: Theme.of(context).primaryColor,
                                buttonColor: Theme.of(context).hintColor,
                                onPressed: (){
                                  subTotal = 0; productDiscount = 0; total = 0; payable = 0; couponAmount = 0; extraDiscount = 0; productTax = 0;
                                  cartController.customerCartList[Get.find<CartController>().customerIndex].cart!.clear();
                                  cartController.removeAllCart();
                                  cartController.setReturnAmountToZero();
                                },
                              )),
                              const SizedBox(width: Dimensions.paddingSizeSmall,),

                              Expanded(child: CustomButtonWidget(
                                buttonText: 'place_order'.tr,
                                onPressed: ()=> _onSubmit(),
                              )),


                            ]),
                          );
                        }),
                        const SizedBox(height: Dimensions.paddingSizeRevenueBottom,),
                      ],),
                    ],);
                  }
              ) )
            ],
          ),
        ),
      ),
    );
  }


  double _getAmount(List<customer.TemporaryCartListModel>? customerCartList, int customerIndex, AmountType amountType ){
    double amount = 0;
    if((customerCartList?.isNotEmpty ?? false)){
      if(amountType == AmountType.discount) {
        for(int i=0; i< (customerCartList?[customerIndex].cart?.length ?? 0); i++ ){

          if(customerCartList?[customerIndex].cart?[i].product?.discountType == 'amount') {
            amount = amount + customerCartList![customerIndex].cart![i].product!.discount! * customerCartList[customerIndex].cart![i].quantity!;
          }else if(customerCartList?[customerIndex].cart?[i].product?.discountType == 'percent'){
            amount = amount + (customerCartList![customerIndex].cart![i].product!.discount!/100) * customerCartList[customerIndex].cart![i].product!.sellingPrice! * customerCartList[customerIndex].cart![i].quantity!;
          }

        }
      }else if(amountType == AmountType.tax) {
        if((customerCartList?.isNotEmpty ?? false)){
          for(int i=0; i< (customerCartList?[customerIndex].cart?.length ?? 0); i++ ){

            amount = amount + (customerCartList![customerIndex].cart![i].product!.tax! / 100
            ) * customerCartList[customerIndex].cart![i].product!.sellingPrice! * customerCartList[customerIndex].cart![i].quantity!;

          }
        }
      }
    }

    return amount;
  }



  void _onSubmit() {
    final CartController cartController = Get.find<CartController>();
    final TransactionController transactionController = Get.find<TransactionController>();

    if(cartController.customerCartList.isEmpty || cartController.customerCartList[Get.find<CartController>().customerIndex].cart!.isEmpty){
      showCustomSnackBarHelper('please_select_at_least_one_product'.tr);
    } else if(transactionController.selectedFromAccountId == null){
      showCustomSnackBarHelper('select_payment_method'.tr);
    } else if( transactionController.selectedFromAccountId == 1 && cartController.collectedCashController.text.trim().isEmpty){
      showCustomSnackBarHelper('please_pay_first'.tr);
    }else if(transactionController.selectedFromAccountId == 1 &&  double.parse(cartController.collectedCashController.text.trim()) < total){
      showCustomSnackBarHelper('please_pay_full_amount'.tr);
    }
    else{
      showAnimatedDialogHelper(context,
          ConfirmPurchaseDialogWidget(
              onYesPressed: cartController.isLoading? null : () {
                List<Cart> carts = [];
                productDiscount = 0;
                productTax = 0;
                for (int index = 0; index < cartController.customerCartList[cartController.customerIndex].cart!.length; index++) {
                  CartModel cart = cartController.customerCartList[cartController.customerIndex].cart![index];
                  carts.add(Cart(
                    cart.product!.id.toString(),
                    cart.price.toString(),
                    cart.product!.discountType == 'amount'?
                    productDiscount + cart.product!.discount! : productDiscount + ((cart.product!.discount!/100)*cart.product!.sellingPrice!),
                    cart.quantity,
                    productTax + ((cart.product!.tax!/100) * cart.product!.sellingPrice!),
                  ));
                }



                PlaceOrderModel placeOrderBody = PlaceOrderModel(
                  cart: carts,
                  couponDiscountAmount: cartController.couponCodeAmount,
                  couponCode: cartController.coupons?.couponCode,
                  orderAmount: cartController.amount,
                  userId: cartController.customerId,
                  collectedCash: transactionController.selectedFromAccountId == 0? double.parse(cartController.customerWalletController.text.trim()) :
                  transactionController.selectedFromAccountId == 1?  double.parse(cartController.collectedCashController.text.trim()) :  0.0,
                  extraDiscountType: cartController.selectedDiscountType,
                  extraDiscount: cartController.extraDiscountController.text.trim().isEmpty? 0.0 : double.parse(PriceConverterHelper.discountCalculationWithOutSymbol(context, subTotal, cartController.extraDiscountAmount, cartController.selectedDiscountType)),
                  returnedAmount: cartController.returnToCustomerAmount,
                  type: Get.find<TransactionController>().selectedFromAccountId,
                  transactionRef: transactionController.selectedFromAccountId != 0 && transactionController.selectedFromAccountId != 1 ? cartController.collectedCashController.text.trim():'',
                );



                cartController.placeOrder(placeOrderBody).then((value){
                  if(value.isOk){
                    couponAmount = 0;
                    extraDiscount = 0;
                    Get.find<ProductController>().getLimitedStockProductList(1);
                  }
                });

              }
          ),
          dismissible: false,
          isFlip: false);
    }
  }
}



