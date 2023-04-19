import 'package:flutter/material.dart';
import 'package:kadena_multisig/utils/constants.dart';

enum CustomButtonType { primary, secondary, success, failure }

class CustomButtonWidget extends StatelessWidget {
  final CustomButtonType type;
  final Widget child;
  final VoidCallback? onTap;
  final double padding;

  const CustomButtonWidget({
    super.key,
    required this.type,
    required this.child,
    required this.onTap,
    this.padding = 16,
  });

  Color get _backgroundColor {
    switch (type) {
      case CustomButtonType.primary:
        return StyleConstants.primaryColor;
      case CustomButtonType.secondary:
        return Colors.transparent;
      case CustomButtonType.success:
        return StyleConstants.successColor;
      case CustomButtonType.failure:
        return StyleConstants.errorColor;
    }
  }

  BorderSide get _borderSide {
    switch (type) {
      case CustomButtonType.secondary:
        return const BorderSide(width: 2, color: Color(0xFF2980B9));
      default:
        return BorderSide.none;
    }
  }

  TextStyle get _textTheme {
    switch (type) {
      case CustomButtonType.secondary:
        return const TextStyle(fontSize: 18, color: Color(0xFF2980B9));
      default:
        return const TextStyle(fontSize: 18, color: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(padding),
        backgroundColor: _backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: _borderSide,
        ),
        // side: _borderSide,
      ),
      child: Center(
        child: DefaultTextStyle.merge(
          style: _textTheme,
          child: child,
        ),
      ),
    );
  }
}
