import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:six_pos/features/reports/controller/reports_controller.dart';
import '../../../common/widgets/custom_button_widget.dart';
import '../../../common/widgets/custom_field_with_title_widget.dart';
import '../../../common/widgets/custom_header_widget.dart';
import '../../../common/widgets/custom_text_field_widget.dart';
import '../../../util/images.dart';
import 'package:http/http.dart' as http;


class ReportDataScreen extends StatelessWidget {
  const ReportDataScreen({Key? key,required this.index}) : super(key: key);
  final int index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: ReportDatePicker(index: index,)),
    );
  }
}
class ReportDatePicker extends StatefulWidget {
  final int index;
  const ReportDatePicker({Key? key,required this.index}) : super(key: key);
  @override
  ReportDatePickerState createState() => ReportDatePickerState();
}

class ReportDatePickerState extends State<ReportDatePicker> {
  DateTime fromDate=DateTime.now().toLocal();
  DateTime toDate=DateTime.now().toLocal();
  TextEditingController userIdController = TextEditingController();
  File? pdfFile;
  String ?pdfUrl;
  bool isLoading = false;
  Future<void> loadNetwork() async {
    var url = pdfUrl;
    if (url != null) {
      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final filename = basename(url);
      final dir = await getApplicationDocumentsDirectory();
      var file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes, flush: true);
      setState(() {
        pdfFile = file;
      });}
  }
  Future<void> downloadNetwork(context) async {
    if (pdfUrl != null) {
      // Request storage permission
      await Permission.storage.request();
      if (await Permission.storage.isGranted) {
        setState(() {
          isLoading = true;
        });

        // Download the PDF
        final response = await http.get(Uri.parse(pdfUrl!));
        final bytes = response.bodyBytes;
        final filename = basename(pdfUrl!);
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$filename');

        // Save the PDF to the local file system
        await file.writeAsBytes(bytes, flush: true);
        setState(() {
          pdfFile = file;
          isLoading = false;
        });

        // Optionally, you can show a download complete message or toast here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF downloaded successfully!')),
        );
      }
    }
  }

  Future<void> downloadPdf(context) async {
    if (pdfUrl != null) {
      await downloadNetwork(context);
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(builder: (reportController) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomHeaderWidget(
              title: '${'search'.tr} ${reportController.reportList[widget.index]}',
              headerImage: Images.report,
            ),
            InkWell(
              onTap: () => _selectFromDate(context),
              child: CustomFieldWithTitleWidget(
                customTextField: CustomTextFieldWidget(
                  isEnabled: false,
                  fillColor: Colors.transparent,
                  hintText:  "${fromDate.toLocal()}".split(' ')[0],
                  inputType: TextInputType.datetime,
                ),
                title: 'from'.tr,
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () => _selectToDate(context),
              child: CustomFieldWithTitleWidget(
                customTextField: CustomTextFieldWidget(
                  isEnabled: false,
                  fillColor: Colors.transparent,
                  hintText: "${toDate.toLocal()}".split(' ')[0],
                  inputType: TextInputType.datetime,
                ),
                title: 'to'.tr,
              ),
            ),
            if(widget.index==0)
              CustomFieldWithTitleWidget(
                customTextField: CustomTextFieldWidget(
                  isEnabled: true,
                  fillColor: Colors.transparent,
                  hintText:  "user Id like:85512",
                  inputType: TextInputType.number,
                  controller: userIdController,
                ),
                title: 'customer_id'.tr,
              ),
            const SizedBox(height: 10),
            CustomButtonWidget(
              isLoading: reportController.isLoading,
              buttonText: 'search'.tr,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (widget.index == 0) {
                    pdfUrl = await reportController.getUserActivitiesReport(
                      '${fromDate.toLocal()}'.split(' ')[0],
                      '${toDate.toLocal()}'.split(' ')[0],
                      'search'.tr == 'Search' ? 'en' : 'ar',
                      userId: userIdController.text.isNotEmpty?userIdController.text.trim():null
                    );
                  }
                  else if (widget.index == 4) {
                    pdfUrl = await reportController.getTopProductReport(
                      '${fromDate.toLocal()}'.split(' ')[0],
                      '${toDate.toLocal()}'.split(' ')[0],
                      'most_sales',
                      'search'.tr == 'Search' ? 'en' : 'ar',
                    );
                  } else if (widget.index == 7) {
                    pdfUrl = await reportController.getLowProductReport(
                      '${fromDate.toLocal()}'.split(' ')[0],
                      '${toDate.toLocal()}'.split(' ')[0],
                      'least_sales',
                      'search'.tr == 'Search' ? 'en' : 'ar',
                    );
                  }

                  await loadNetwork();

                  setState(() {
                    isLoading = false;
                  });
                },
            ),
            reportController.isLoading
                ? const Padding(
                  padding: EdgeInsets.only(top: 150.0),
                  child: Center(child: Center(child: CircularProgressIndicator())),
                )
                :pdfFile != null && pdfUrl!.isNotEmpty
                ? Expanded(
              child: Stack(
                children: [
                  Center(
                    child: PDFView(
                      filePath: pdfFile!.path,
                      key: ValueKey(pdfFile!.path),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 10,
                    child: InkWell(
                      onTap: () {
                        downloadPdf(context);
                      },
                      child: const Icon(Icons.print),
                    ),
                  ),
                ],
              ),
            ):Container(),
          ],
        ),
      );
    });
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fromDate ,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != fromDate) {
      setState(() {
        fromDate = pickedDate;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: toDate ,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != toDate) {
      setState(() {
        toDate = pickedDate;
      });
    }
  }
}
