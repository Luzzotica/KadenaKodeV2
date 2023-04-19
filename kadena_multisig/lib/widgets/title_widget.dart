import 'package:flutter/material.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/widgets/custom_button_widget.dart';

class TitleWidget extends StatefulWidget {
  const TitleWidget({
    super.key,
    required this.title,
    required this.child,
    this.collapsible = false,
    this.actionTitle = '',
    this.action,
  });

  final String title;
  final Widget child;
  final bool collapsible;
  final String actionTitle;
  final void Function()? action;

  @override
  State<TitleWidget> createState() => _TitleWidgetState();
}

class _TitleWidgetState extends State<TitleWidget> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: widget.collapsible
              ? () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (widget.action != null)
                  CustomButtonWidget(
                    type: CustomButtonType.primary,
                    onTap: widget.action,
                    child: Text(widget.actionTitle,
                        style: Theme.of(context).textTheme.titleLarge!),
                  ),
                const SizedBox(width: 8),
                if (widget.collapsible)
                  Icon(
                    _isExpanded ? Icons.visibility : Icons.visibility_off,
                    color: StyleConstants.primaryColor,
                  ),
              ],
            ),
          ),
        ),
        // const SizedBox(height: 8),
        if (_isExpanded) widget.child,
      ],
    );
  }
}
