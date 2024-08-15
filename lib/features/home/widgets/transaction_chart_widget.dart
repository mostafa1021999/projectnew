import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/controllers/account_controller.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/images.dart';
import 'package:six_pos/util/styles.dart';


class TransactionChartWidget extends StatefulWidget {
  final double? maxYExpense;
  final double? maxYIncome;

  const TransactionChartWidget({Key? key, this.maxYExpense, this.maxYIncome}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TransactionChartWidgetState();
}

class TransactionChartWidgetState extends State<TransactionChartWidget> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    List<int> range =[];
    int maxI = widget.maxYIncome!.ceil();
    for(int i = 1; i<= 5; i++){
      range.add((maxI/i).ceil());
    }

    double maxV = Get.find<AccountController>().maxValueForChard;


    return AspectRatio(
      aspectRatio: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 14,height: 14 ,child: Image.asset(Images.pieChart)),
              const SizedBox(width: 5,),
              Text('earning_statistics'.tr, style: fontSizeRegular.copyWith(
              color: ColorResources.getTextColor(),
              fontSize: Dimensions.fontSizeDefault),),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     children: [
                       Icon(Icons.circle,size: 7,color: Theme.of(context).primaryColor),
                       Text('income'.tr,
                         style: fontSizeRegular.copyWith(
                  color: ColorResources.getTextColor(),
                  fontSize: Dimensions.fontSizeSmall),
                  ),
                     ],
                   ),
                   const SizedBox(width: Dimensions.paddingSizeSmall,),
                   Row(
                     children: [
                       Icon(Icons.circle,size: 7,color: Theme.of(context).secondaryHeaderColor.withOpacity(.3)),
                       Text('expense'.tr,
                         style: fontSizeRegular.copyWith(
                             color: ColorResources.getTextColor(),
                             fontSize: Dimensions.fontSizeSmall),
                  ),
                     ],
                   ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: LineChart(LineChartData(
              lineTouchData: lineTouchData1,
              gridData: gridData,
              titlesData: titlesData1,
              borderData: borderData,
              lineBarsData: lineBarsData1,
              minX: 0,
              maxX: 13,
              maxY: maxV,
              minY: 0,
            ),
              duration: const Duration(milliseconds: 250),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }




  LineTouchData get lineTouchData1 => const LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      // tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),

  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarDataExpense,
    lineChartBarDataIncome,
  ];

  LineTouchData get lineTouchData2 => const LineTouchData(
    enabled: true,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );




  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff72719b),
      fontWeight: FontWeight.normal,
      fontSize: Dimensions.paddingSizeExtraSmall,
    );
    Widget? text;
    switch (value.toInt()) {
      case 1:
        text = const Text('JAN', style: style);
        break;
      case 2:
        text = const Text('FEB', style: style);
        break;
      case 3:
        text = const Text('MAR', style: style);
        break;
      case 4:
        text = const Text('APR', style: style);
        break;
      case 5:
        text = const Text('MAY', style: style);
        break;
      case 6:
        text = const Text('JUN', style: style);
        break;
      case 7:
        text = const Text('JUL', style: style);
        break;
      case 8:
        text = const Text('AUG', style: style);
        break;
      case 9:
        text = const Text('SEPT', style: style);
        break;
      case 10:
        text = const Text('OCT', style: style);
        break;
      case 11:
        text = const Text('NOV', style: style);
        break;
      case 12:
        text = const Text('DEC', style: style);
        break;

    }

    return Padding(padding: const EdgeInsets.only(top: 10.0), child: text);
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 1,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData => const FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: const Border(
      bottom: BorderSide(color: Color(0xff4e4965), width: 1),
      left: BorderSide(color: Colors.transparent),
      right: BorderSide(color: Colors.transparent),
      top: BorderSide(color: Colors.transparent),
    ),
  );

  LineChartBarData get lineChartBarDataExpense => LineChartBarData(
    isCurved: false,
    color: Theme.of(context).secondaryHeaderColor.withOpacity(.3),
    barWidth: Dimensions.barWidthFlowChart,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: true),
    belowBarData: BarAreaData(show: false),
    spots: Get.find<AccountController>().expanseChartList,
  );

  LineChartBarData get lineChartBarDataIncome => LineChartBarData(
    isCurved: false,
    color:Theme.of(context).primaryColor,
    barWidth: Dimensions.barWidthFlowChart,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      color: const Color(0x00aa4cfc),
    ),
    spots: Get.find<AccountController>().incomeChartList,
  );

}
