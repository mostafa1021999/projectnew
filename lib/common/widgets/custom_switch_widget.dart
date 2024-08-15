import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSwitchWidget extends StatelessWidget {
  final bool value;
  final Color? activeColor;
  final Function(bool value) onChanged;

  const CustomSwitchWidget({
    Key? key, required this.value,
    this.activeColor,
    required this.onChanged,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.8,
      child: CupertinoSwitch(
          value: value,
          activeColor: activeColor ?? Theme.of(context).primaryColor,
          onChanged: (value) => onChanged(value),
      ),
    );
  }
}
