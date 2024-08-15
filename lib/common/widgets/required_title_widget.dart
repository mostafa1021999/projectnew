import 'package:flutter/material.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class RequiredTitleWidget extends StatelessWidget {
  final String title;
  final bool isRequired;
  const RequiredTitleWidget({Key? key, required this.title, this.isRequired = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  RichText(
      text: TextSpan(
        text: title, style: fontSizeMedium.copyWith(
        fontSize: Dimensions.fontSizeLarge,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
        children: <TextSpan>[
          TextSpan(text: '  *', style: fontSizeBold.copyWith(color: Colors.red)),
        ],
      ),
    );
  }
}
