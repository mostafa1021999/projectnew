import 'package:flutter/material.dart';
import 'package:six_pos/common/widgets/custom_asset_image_widget.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String headerImage;
  final String title;
  const CustomHeaderWidget({Key? key, required this.title, required this.headerImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( color: Theme.of(context).primaryColor.withOpacity(0.06), child: Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row( mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAssetImageWidget(headerImage, height: 30),
          const SizedBox(width: Dimensions.paddingSizeSmall),
          Text(title, style: fontSizeMedium.copyWith(
            fontSize: Dimensions.fontSizeOverLarge,
            color: Theme.of(context).primaryColor,
          ),),
        ],
      ),
    ),);
  }
}
