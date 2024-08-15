
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:six_pos/common/widgets/no_data_widget.dart';
import 'package:six_pos/common/widgets/paginated_list_widget.dart';
import 'package:six_pos/features/brand/controllers/brand_controller.dart';
import 'package:six_pos/features/brand/widgets/brand_card_widget.dart';

class BrandListWidget extends StatelessWidget {
  final ScrollController scrollController;
  const BrandListWidget({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<BrandController>(
      builder: (brandController) {

        return brandController.brandModel == null ? const _BrandShimmer() : (brandController.brandModel?.brandList?.isNotEmpty ?? false) ? PaginatedListWidget(
          scrollController: scrollController,
          onPaginate: (int? offset) async => await brandController.getBrandList(offset ?? 1),
          totalSize: brandController.brandModel?.totalSize,
          offset: brandController.brandModel?.offset,
          itemView: ListView.builder(
              shrinkWrap: true,
              itemCount: brandController.brandModel?.brandList?.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (ctx,index){
                return BrandCardWidget(brand: brandController.brandModel?.brandList?[index]);
              }),
        ) : const NoDataWidget();
      },
    );
  }
}

class _BrandShimmer extends StatelessWidget {
  const _BrandShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: true,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.white,
                ),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 20.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 20.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 100.0,
                        height: 20.0,
                        color: Colors.white,
                      ),
                    ],
                  ),),
                const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0)),

                const Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.edit,color: Colors.white),
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0)),
                    Icon(Icons.delete_forever_rounded,color: Colors.white),

                  ],
                )
              ],
            ),
          ),
          itemCount: 12,
        ));
  }
}

