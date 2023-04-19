import 'package:flutter/material.dart';

class DecimalInputWidget extends StatelessWidget {
  const DecimalInputWidget({
    super.key,
    required this.value,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  final double value;
  final TextEditingController controller;
  final void Function(double) onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    if (controller.text.isEmpty) {
      controller.text = value.toString();
    }

    return TextFormField(
      controller: controller,
      expands: true,
      maxLines: null,
      keyboardType: TextInputType.number,
      onChanged: (String newValue) {
        onChanged(double.tryParse(
              newValue,
            ) ??
            0);
      },
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
