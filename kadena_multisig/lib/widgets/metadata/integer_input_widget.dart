import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntegerInputWidget extends StatelessWidget {
  const IntegerInputWidget({
    super.key,
    required this.value,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  final int value;
  final TextEditingController controller;
  final void Function(int) onChanged;
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
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (String newValue) {
        onChanged(int.tryParse(
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
