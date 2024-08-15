import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:six_pos/features/product/controllers/product_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';
import 'package:six_pos/common/widgets/custom_app_bar_widget.dart';
import 'package:six_pos/common/widgets/custom_button_widget.dart';
import 'package:six_pos/common/widgets/custom_drawer_widget.dart';
import 'package:six_pos/common/widgets/custom_header_widget.dart';
import 'package:six_pos/helper/show_custom_snackbar_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductBulkImportScreen extends StatefulWidget {
  const ProductBulkImportScreen({Key? key}) : super(key: key);

  @override
  State<ProductBulkImportScreen> createState() => _ProductBulkImportScreenState();
}

class _ProductBulkImportScreenState extends State<ProductBulkImportScreen> {

  final List<String> fileExtensions = ['xlsx', 'xlsm', 'xlsb', 'xltx'];

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
      body: Column(
        children: [
          CustomHeaderWidget(title: 'bulk_import'.tr, headerImage: Images.import),

          GetBuilder<ProductController>(
            builder: (importController) {
              return Column(
                children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeSmall),
                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('instructions'.tr, style: fontSizeBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                     const SizedBox(height: Dimensions.paddingSizeSmall),
                     Text('instructions_details'.tr),


                     const SizedBox(height: Dimensions.paddingSizeLarge,),

                     Row(children: [
                       SizedBox(width: Dimensions.iconSizeSmall, child: Image.asset(Images.import)),
                       const SizedBox(width: Dimensions.iconSizeSmall),
                       Text('import'.tr, style: fontSizeBold.copyWith(fontSize: Dimensions.fontSizeLarge,color: ColorResources.getTitleColor())),
                       const Spacer(),
                      InkWell(
                        onTap : () async {
                          importController.getSampleFile().then((value) async {
                            _launchUrl(Uri.parse('${importController.bulkImportSampleFilePath}'));
                          });

                        },
                        child: Row(children: [
                          Text('download_format'.tr, style: fontSizeRegular.copyWith(color: ColorResources.downloadFormat)),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          SizedBox(width: Dimensions.iconSizeSmall, child: Image.asset(Images.downloadFormat)),
                        ],),
                      )
                     ],),
                   ],
                  ),),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                  InkWell(
                    onTap: ()async{
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: fileExtensions,
                      );
                      if (result != null) {
                        File file = File(result.files.single.path!);
                        importController.setSelectedFileName(file);

                      } else {

                      }
                    },
                    child: Builder(
                      builder: (context) {
                        return Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 100,child: Image.asset(Images.upload)),

                            importController.selectedFileForImport != null ? Text(
                              basename(importController.selectedFileForImport!.path),
                              style: fontSizeRegular.copyWith(color: ColorResources.downloadFormat.withOpacity(.5)),
                            ) : Text('upload_file'.tr, style: fontSizeRegular.copyWith(
                              color: ColorResources.downloadFormat.withOpacity(.5),
                            )),

                          ],);
                      }
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeDefault,
                      vertical: Dimensions.paddingSizeLarge,
                    ),
                    child: CustomButtonWidget(
                      buttonText: 'submit'.tr,
                      isLoading: importController.isLoading,
                      onPressed: () async {
                        if(importController.selectedFileForImport != null){
                          if(importController.checkFileExtension(fileExtensions, importController.selectedFileForImport!.path)){
                            importController.bulkImportFile();
                          }else{
                            showCustomSnackBarHelper('please_submit_correct_file'.tr);
                          }
                        }else{
                          showCustomSnackBarHelper('select_file_first'.tr);
                        }
                      },
                    ),
                  ),
                ],
              );
            }
          )
        ],
      ),
    );
  }

}

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
