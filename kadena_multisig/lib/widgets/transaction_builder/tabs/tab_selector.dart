import 'package:flutter/material.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/widgets/custom_button_widget.dart';

import 'package:kadena_multisig/widgets/transaction_builder/tabs/tab_widget.dart';

class TabSelector extends StatelessWidget {
  const TabSelector({
    super.key,
    // required this.prefix,
    required this.tabTitles,
    int? selectedIndex = 0,
    required this.onTabSelected,
    required this.onTabClose,
    required this.onTabAdd,
  }) : selectedIndex = selectedIndex ?? 0;

  // final String prefix;
  final List<String> tabTitles;
  final int selectedIndex;
  final void Function(int) onTabSelected;
  final void Function(int) onTabClose;
  final void Function() onTabAdd;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [];
    for (var i = 0; i < tabTitles.length; i++) {
      tabs.add(
        TabWidget(
          title: tabTitles[i],
          index: i,
          isSelected: selectedIndex == i,
          onTap: _onTabSelected,
          onClose: _onTabClose,
        ),
      );
      tabs.add(const SizedBox(width: 8.0));
    }

    tabs.add(
      SizedBox(
        width: 40,
        height: 40.0,
        child: CustomButtonWidget(
          type: CustomButtonType.secondary,
          padding: 2,
          onTap: onTabAdd,
          child: const Icon(Icons.add),
        ),
      ),
    );

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: tabs,
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  void _onTabSelected(int index) {
    onTabSelected(index);
  }

  void _onTabClose(int index) {
    onTabClose(index);
  }
}
