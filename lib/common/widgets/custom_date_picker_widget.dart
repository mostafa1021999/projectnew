import 'package:flutter/material.dart';
import 'package:six_pos/util/color_resources.dart';
import 'package:six_pos/util/dimensions.dart';
import 'package:six_pos/util/styles.dart';

class CustomDatePickerWidget extends StatefulWidget {
  final String? title;
  final String? text;
  final String? image;
  final bool requiredField;
  final Function? selectDate;
  const CustomDatePickerWidget({Key? key, this.title,this.text,this.image, this.requiredField = false,this.selectDate}) : super(key: key);

  @override
  State<CustomDatePickerWidget> createState() => _CustomDatePickerWidgetState();
}

class _CustomDatePickerWidgetState extends State<CustomDatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: Dimensions.paddingSizeDefault,right: Dimensions.paddingSizeDefault),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

        RichText(
          text: TextSpan(
            text: widget.title, style: fontSizeRegular.copyWith(color: Theme.of(context).primaryColor),
            children: <TextSpan>[
              widget.requiredField ? TextSpan(text: '  *', style: fontSizeBold.copyWith(color: Colors.red)) : const TextSpan(),
            ],
          ),
        ),

        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        InkWell(
          onTap: widget.selectDate as void Function()?,
          child: Container(
            height: 50,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              border: Border.all(color: ColorResources.primaryColor,width: 0.1),
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Text(widget.text!, style: fontSizeLight.copyWith(fontSize: Dimensions.fontSizeSmall),),

              SizedBox(width: 20,height: 20,child: Image.asset(widget.image!)),
            ],
            ),
          ),
        ),

      ],),
    );
  }
}
