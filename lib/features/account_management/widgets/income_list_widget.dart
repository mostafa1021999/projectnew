import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/features/account_management/controllers/income_controller.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/features/user/widgets/account_shimmer_widget.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/features/account_management/widgets/income_info_card_widget.dart';

class IncomeListWidget extends StatefulWidget {
  final ScrollController? scrollController;
  const IncomeListWidget({Key? key, this.scrollController}) : super(key: key);

  @override
  State<IncomeListWidget> createState() => _IncomeListWidgetState();
}

class _IncomeListWidgetState extends State<IncomeListWidget> {
  @override
  Widget build(BuildContext context) {
    int offset = 1;
    widget.scrollController?.addListener(() {
      if(widget.scrollController!.position.maxScrollExtent == widget.scrollController!.position.pixels
          && Get.find<IncomeController>().incomeList != null &&
          Get.find<IncomeController>().incomeList!.isNotEmpty
          && !Get.find<IncomeController>().isLoading) {
        int? pageSize;
        pageSize = Get.find<IncomeController>().incomeListLength;

        if(offset < pageSize!) {
          offset++;
          Get.find<IncomeController>().showBottomLoader();
          Get.find<IncomeController>().getIncomeList(offset, reload: false);
        }
      }

    });

    return GetBuilder<IncomeController>(
      builder: (incomeController) {

        return Column(children: [
          incomeController.incomeList == null ? const CustomLoaderWidget() :  !incomeController.isFirst ? incomeController.incomeList!.isNotEmpty ?
          ListView.builder(
            shrinkWrap: true,
              itemCount:  incomeController.incomeList!.length,
              physics:  const BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return IncomeInfoCardWidget(income: incomeController.incomeList![index], index: index);

              }) : const NoDataWidget(): const AccountShimmerWidget(),
          incomeController.isLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox.shrink(),

        ]);
      },
    );
  }
}
