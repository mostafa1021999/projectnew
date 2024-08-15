
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:six_pos/common/widgets/custom_loader_widget.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/coupon/controllers/coupon_controller.dart';
import 'package:six_pos/features/coupon/widgets/coupon_card_widget.dart';


class CouponListWidget extends StatelessWidget {
  final ScrollController scrollController;
  const CouponListWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CouponController>(
      builder: (couponController) {

        return couponController.couponModel == null ? const CustomLoaderWidget(
        ) : (couponController.couponModel?.couponList?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          onPaginate: (int? offset) async => await couponController.getCouponList(offset ?? 1),
          totalSize: couponController.couponModel?.totalSize,
          offset: couponController.couponModel?.offset,
          itemView: ListView.builder(
            shrinkWrap: true,
            itemCount: couponController.couponModel?.couponList?.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx,index){
              return CouponCardWidget(
                coupon: couponController.couponModel?.couponList?[index],
                index: index,
              );

            },
          ),
        ) : const NoDataWidget();
      },
    );
  }
}
