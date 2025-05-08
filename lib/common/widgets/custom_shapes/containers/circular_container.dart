import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class LCircularContainer extends StatelessWidget {
  const LCircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.backgroundColor = LColors.white,
    this.child,
  });

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Color backgroundColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
