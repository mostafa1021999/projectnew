import 'dart:async';
import 'dart:convert';

// import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:six_pos/common/models/config_model.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/order/controllers/order_controller.dart';
import 'package:six_pos/features/order/domain/models/invoice_model.dart';
import 'package:six_pos/helper/date_converter_helper.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';



class OrderInvoicePrintScreen extends StatefulWidget {
  final Invoice? invoice;
  final ConfigModel? configModel;
  final int? orderId;
  final double? discountProduct;
  final double? total;
  const OrderInvoicePrintScreen({Key? key, this.invoice, this.configModel, this.orderId, this.discountProduct, this.total}) : super(key: key);

  @override
  State<OrderInvoicePrintScreen> createState() => _OrderInvoicePrintScreenState();
}

class _OrderInvoicePrintScreenState extends State<OrderInvoicePrintScreen> {

  bool connected = false;
  List<BluetoothInfo>? availableBluetoothDevices;
  bool _isLoading = false;
  final List<int> _paperSizeList = [80, 58];
  int _selectedSize = 80;



  Future<void> getBluetooth() async {
    setState(() {
      _isLoading = true;

    });


    final List<BluetoothInfo> bluetoothDevices = await PrintBluetoothThermal.pairedBluetooths;
    if (kDebugMode) {
      print("Print $bluetoothDevices");
    }
    connected = await PrintBluetoothThermal.connectionStatus;

    if(!connected) {
      Get.find<OrderController>().setBluetoothMacAddress('');
    }

    setState(() {
      availableBluetoothDevices = bluetoothDevices;
      _isLoading = false;

    });

  }

  Future<void> setConnect(String mac) async {
    final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);


    if (result) {
      setState(() {
        connected = true;
      });
    }
  }

  Future<void> printTicket() async {
    setState(() {
      _isLoading = true;
    });

    bool? isConnected = await PrintBluetoothThermal.connectionStatus;
    if (isConnected) {
      List<int> bytes = await _printReceiveTest();
      final result = await PrintBluetoothThermal.writeBytes(bytes);
      if (kDebugMode) {
        print("Print $result");
      }
    }
    setState(() {
      _isLoading = false;
    });
  }




  @override
  void initState() {
    super.initState();

    getBluetooth();


  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer: const CustomDrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault,
          vertical: Dimensions.paddingSizeSmall,
        ),
        child: Column(
          children: [


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('paired_bluetooth'.tr, style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

                      SizedBox(height: 20, width: 20,
                        child: _isLoading ?  CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ) : InkWell(
                          onTap: ()=> getBluetooth(),
                          child: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
                        ),
                      ),

                    ],
                  ),

                  SizedBox(width: 100, child: DropdownButton<int>(
                    hint: Text('select'.tr),
                    value: _selectedSize,
                    items: _paperSizeList.map((int? value) {
                      return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value''mm'));
                    }).toList(),
                    onChanged: (int? value) {
                      setState(() {
                        _selectedSize = value!;

                      });
                    },
                    isExpanded: true, underline: const SizedBox(),
                  ))


                ],
              ),
            ),

            Expanded(child: availableBluetoothDevices != null && (availableBluetoothDevices?.length ?? 0) > 0 ? ListView.builder(
                itemCount: availableBluetoothDevices?.length,
                itemBuilder: (context, index) {
                  return GetBuilder<OrderController>(
                    builder: (orderController) {
                      bool isConnected = connected &&  availableBluetoothDevices![index].macAdress == orderController.getBluetoothMacAddress();

                      return Stack(
                        children: [
                          ListTile(
                            selected: isConnected,
                            onTap: () {

                              if(availableBluetoothDevices?[index].macAdress.isNotEmpty ?? false) {
                                if(!connected) {
                                  orderController.setBluetoothMacAddress(availableBluetoothDevices?[index].macAdress);
                                }

                                setConnect(availableBluetoothDevices?[index].macAdress ?? '');
                              }


                            },
                            title: Text(availableBluetoothDevices?[index].name ?? ''),
                            subtitle:  Text(isConnected ? 'connected'.tr : "click_to_connect".tr, style: fontSizeLight.copyWith(
                              color: isConnected ? null : Theme.of(context).primaryColor,
                            )),
                          ),

                          if(availableBluetoothDevices?[index].macAdress == orderController.getBluetoothMacAddress())
                            Positioned.fill(
                              child: Align(alignment: Alignment.topRight, child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: Dimensions.paddingSizeExtraSmall,
                                  horizontal: Dimensions.paddingSizeLarge,
                                ),
                                child: Icon(Icons.check_circle_outline_outlined, color: Theme.of(context).primaryColor,),
                              )),
                            ),

                        ],
                      );
                    }
                  );
                },
              ) : const NoDataWidget()),

            CustomButtonWidget(
              isLoading: _isLoading,
              onPressed: connected ? printTicket : null,
              buttonText: 'print_invoice'.tr,
            ),
          ],
        ),
      ),
    );
  }



  Future<List<int>>  _printReceiveTest() async {
    final OrderController orderController = Get.find<OrderController>();


    double changeAmount = 0;

    if(orderController.invoice?.account?.account?.toLowerCase() == 'cash') {
      changeAmount = (orderController.invoice!.collectedCash! - (widget.total ?? 0));
    }


    final profile = await CapabilityProfile.load();
    final generator = Generator(_selectedSize == 80 ? PaperSize.mm80 : PaperSize.mm58,  profile);
    List<int> bytes = [];

    bytes += generator.text(widget.configModel?.businessInfo?.shopName ?? '',
        styles: const PosStyles(align: PosAlign.center,bold: true));
    bytes += generator.text(widget.configModel?.businessInfo?.shopAddress ?? '',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(widget.configModel?.businessInfo?.shopPhone ?? '',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(widget.configModel?.businessInfo?.shopEmail ?? '',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(widget.configModel?.businessInfo?.vat ?? '',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('...............................................................', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(' ', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.row([
      PosColumn(
        text: '${'invoice'.tr.toUpperCase()}#${widget.orderId}',
        width: 6,
        styles: const PosStyles(align: PosAlign.left, underline: true),
      ),

      PosColumn(
        text: 'payment_method'.tr,
        width: 6,
        styles: const PosStyles(align: PosAlign.right, underline: true),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: DateConverterHelper.dateTimeStringToMonthAndTime(widget.invoice!.createdAt!),
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),

      PosColumn(
        text: widget.invoice?.account?.account ?? '',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'sl'.tr.toUpperCase(),
        width: 2,
        styles: const PosStyles(align: PosAlign.left),
      ),

      PosColumn(
        text: 'product_info'.tr,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'qty'.tr,
        width: 1,
        styles: const PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: 'price'.tr,
        width: 3,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.text('...............................................................', styles: const PosStyles(align: PosAlign.center));

    for(int i =0; i< widget.invoice!.details!.length; i++){
      bytes += generator.row([
        PosColumn(
          text: '${i+1}',
          width: 1,
          styles: const PosStyles(align: PosAlign.left),
        ),

        PosColumn(
          text: '${jsonDecode(widget.invoice!.details![i].productDetails!)['name']}',
          width: 7,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: widget.invoice!.details![i].quantity.toString(),
          width: 1,
          styles: const PosStyles(align: PosAlign.right),
        ),
        PosColumn(
          text: '${widget.invoice!.details![i].price}',
          width: 3,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }



    bytes += generator.text('...............................................................', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.row([
      PosColumn(
        text: 'subtotal'.tr,
        width: 6,
        styles: const PosStyles(align: PosAlign.left,),
      ),

      PosColumn(
        text: '${orderController.subTotalProductAmount}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right,),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'product_discount'.tr,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),

      PosColumn(
        text: '${widget.discountProduct}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'coupon_discount'.tr,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),

      PosColumn(
        text: '${widget.invoice!.couponDiscountAmount}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'extra_discount'.tr,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),

      PosColumn(
        text: '${widget.invoice!.extraDiscount}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'tax'.tr,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),

      PosColumn(
        text: '${widget.invoice!.totalTax}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.text('...............................................................', styles: const PosStyles(align: PosAlign.center));

    bytes += generator.row([
      PosColumn(
        text: 'total'.tr,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),

      PosColumn(
        text: '${widget.total}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'change'.tr,
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),

      PosColumn(
        text: '$changeAmount',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);




    bytes += generator.text(' ', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('...............................................................', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('terms_and_condition'.tr, styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(' ',);
    bytes += generator.text('terms_and_condition_details'.tr, styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(' ',);
    bytes += generator.text('${'powered_by'.tr} : ${widget.configModel?.businessInfo?.shopName ?? ''}', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('${'shop_online'.tr} : ${widget.configModel?.businessInfo?.shopName ?? ''}', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text(' ',);

    bytes += generator.cut();

    return bytes;


  }

  String getMacAddress(String device) {
    List list = device.split("#");
    return list[1];
  }

}
