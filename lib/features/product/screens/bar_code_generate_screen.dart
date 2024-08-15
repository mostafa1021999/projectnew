import 'dart:isolate';
import 'dart:ui';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/features/splash/controllers/splash_controller.dart';
import 'package:six_pos/common/models/product_model.dart';
import 'package:six_pos/helper/price_converter_helper.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_field_with_title_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:six_pos/common/widgets/custom_text_field_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class BarCodeGenerateScreen extends StatefulWidget {
  final Products? product;
  const BarCodeGenerateScreen({Key? key, this.product}) : super(key: key);

  @override
  State<BarCodeGenerateScreen> createState() => _BarCodeGenerateScreenState();
}

class _BarCodeGenerateScreenState extends State<BarCodeGenerateScreen> {
  TextEditingController quantityController = TextEditingController();
  int barCodeQuantity = 4;
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    quantityController.text = '4';
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      setState((){ });
    });

    FlutterDownloader.registerCallback((id, status, progress) => downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort send = IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }




  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBarWidget(),
      endDrawer:  const CustomDrawerWidget(),
      body: GetBuilder<ProductController>(
        builder: (barCodeController) {
          return Column(children: [
            CustomHeaderWidget(title: 'bar_code_generator'.tr, headerImage: Images.barCodeGenerate),
            Column(children: [

              Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeDefault),
                child: Column(children: [
                Row(children: [
                  Text('${'code'.tr} : '),
                  Text('${widget.product!.productCode}', style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor))],),

                Row(children: [
                  Text('${'product_name'.tr} : '),
                  Expanded(
                    child: Text('${widget.product!.title}', maxLines: 2,overflow: TextOverflow.ellipsis,
                        style: fontSizeRegular.copyWith(color: Theme.of(context).hintColor)),
                  )],),
              ],),),


              CustomFieldWithTitleWidget(
                limitSet: true,
                setLimitTitle: 'maximum_quantity_270'.tr,
                customTextField: CustomTextFieldWidget(hintText: 'sku_hint'.tr,
                controller: quantityController),
                title: 'qty'.tr,
                requiredField: true,
              ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                const SizedBox(width: Dimensions.fontSizeSmall),
                Expanded(child: CustomButtonWidget(buttonText: 'generate'.tr,
                onPressed: (){
                  if(int.parse(quantityController.text)>270 || int.parse(quantityController.text) ==0){
                    showCustomSnackBarHelper('please_enter_from_1_to_270'.tr);
                  }else{
                    barCodeController.setBarCodeQuantity(int.parse(quantityController.text));
                  }

                })),
                const SizedBox(width: Dimensions.fontSizeSmall),
                Expanded(child: CustomButtonWidget(buttonText: 'download'.tr,
                    onPressed : () async {
                      _launchUrl(Uri.parse('${AppConstants.baseUrl}${AppConstants.barCodeDownload}?id=${widget.product!.id}&quantity=${int.parse(quantityController.text)}'));
                    }
                    ,buttonColor: ColorResources.colorPrint)),
                const SizedBox(width: Dimensions.fontSizeSmall),
                Expanded(child: CustomButtonWidget(buttonText: 'reset'.tr,onPressed: (){
                  quantityController.text = '4';
                  barCodeController.setBarCodeQuantity(4);
                },
                buttonColor: ColorResources.getResetColor(),textColor: ColorResources.getTextColor(),isClear: true)),
                const SizedBox(width: Dimensions.fontSizeSmall),


              ],)
            ],),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: GridView.builder(
                itemCount: barCodeController.barCodeQuantity,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1/1,
                  ), itemBuilder: (barcode, index){
                    return Column(
                      children: [
                        Text('${Get.find<SplashController>().configModel!.businessInfo!.shopName}',
                          style: fontSizeMedium.copyWith(fontSize: Dimensions.fontSizeDefault),),
                        Text('${widget.product!.title}', maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: fontSizeRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),
                        Text(PriceConverterHelper.priceWithSymbol(widget.product!.sellingPrice!)),
                        BarcodeWidget(
                          data: 'code : ${widget.product!.productCode}',style: fontSizeRegular.copyWith(),
                          barcode: Barcode.code128(),

                        ),
                      ],
                    );
              }),
            ))
          ],);
        }
      ),
    );
  }
}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
