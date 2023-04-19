import 'package:flutter/material.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/widgets/custom_button_widget.dart';

class TabWidget extends StatelessWidget {
  static const double padding = 8;

  const TabWidget({
    super.key,
    required this.title,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.onClose,
  });

  final String title;
  final int index;
  final bool isSelected;
  final void Function(int) onTap;
  final void Function(int) onClose;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onTap(index);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(
          left: padding,
          top: padding,
          bottom: padding,
        ),
        backgroundColor: isSelected
            ? StyleConstants.backgroundColorLighter
            : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // side: _borderSide,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: getTheme(context),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8.0),
          SizedBox(
            width: 40,
            height: 40.0,
            child: CustomButtonWidget(
              type: CustomButtonType.secondary,
              padding: 2,
              onTap: () {
                onClose(index);
              },
              child: const Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }

  TextStyle getTheme(BuildContext context) {
    final theme = Theme.of(context).textTheme.headline6!;
    return !isSelected
        ? theme
        : theme.copyWith(
            color: StyleConstants.successColor,
          );
  }
}
