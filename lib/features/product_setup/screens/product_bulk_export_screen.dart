
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/util/app_constants.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:url_launcher/url_launcher.dart';



class ProductBulkExportScreen extends StatefulWidget {
  const ProductBulkExportScreen({Key? key}) : super(key: key);

  @override
  State<ProductBulkExportScreen> createState() => _ProductBulkExportScreenState();
}

class _ProductBulkExportScreenState extends State<ProductBulkExportScreen> {


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const CustomDrawerWidget(),
      appBar: const CustomAppBarWidget(),
      body: GetBuilder<ProductController>(
        builder: (exportController) {
          return Column(children: [

            CustomHeaderWidget(title: 'bulk_export'.tr, headerImage: Images.import),

            InkWell(
              onTap: () async {

               _launchUrl(Uri.parse('${AppConstants.baseUrl}${AppConstants.bulkExportProductUri}'));

              },
              child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 100,child: Image.asset(Images.download)),
                  Text('click_download_button'.tr, textAlign: TextAlign.center,
                    style: fontSizeRegular.copyWith(color: ColorResources.downloadFormat.withOpacity(.5)),),
                ],),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeLarge),
              child: CustomButtonWidget(buttonText: 'download'.tr, onPressed: () async {
                _launchUrl(Uri.parse('${AppConstants.baseUrl}${AppConstants.bulkExportProductUri}'));
              },),
            ),

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