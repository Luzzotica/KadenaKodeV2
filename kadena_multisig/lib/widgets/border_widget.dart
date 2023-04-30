import 'package:flutter/material.dart';

class BorderWidget extends StatelessWidget {
  const BorderWidget({
    super.key,
    required this.child,
    this.backgroundColor = Colors.transparent,
    this.padding = 16,
  });

  final Widget child;
  final Color backgroundColor;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
