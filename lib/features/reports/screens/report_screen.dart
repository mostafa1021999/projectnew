import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_app_bar_widget.dart';
import '../../../common/widgets/custom_category_button_widget.dart';
import '../../../common/widgets/custom_drawer_widget.dart';
import '../../../util/images.dart';
import '../controller/reports_controller.dart';
import '../navigator/report_data.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.01;
    const double height = 180;
    return GetBuilder<ReportController>(builder: (reportController) {
      return Scaffold(
        appBar: const CustomAppBarWidget(isBackButtonExist: true),
        endDrawer: const CustomDrawerWidget(),
        body: GridView.count(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            childAspectRatio: 1/0.6,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            crossAxisCount: 2,children: List.generate(reportController.reportList.length,
                  (index)=> CustomCategoryButtonWidget(
                    buttonText: reportController.reportList[index],
                    icon: Images.report,
                    paddingHorizontal:height,
                    isSelected: false,
                    isDrawer: false,
                    padding: width,
                    onTap: ()=> Get.to(()=>  ReportDataScreen(index: index,)),
                  )), ),


      );}
    );
  }
}
