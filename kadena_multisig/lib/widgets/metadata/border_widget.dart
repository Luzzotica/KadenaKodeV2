import 'package:flutter/material.dart';

class BorderWidget extends StatelessWidget {
  final Widget child;
  final double padding;

  const BorderWidget({
    super.key,
    required this.child,
    this.padding = 16,
  });

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
      ),
      child: child,
    );
  }
}
