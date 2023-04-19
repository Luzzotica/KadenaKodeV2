import 'package:flutter/material.dart';
import 'package:kadena_multisig/utils/constants.dart';

class ChainIdsList extends StatelessWidget {
  final Set<String> chainIds;

  const ChainIdsList({
    super.key,
    required this.chainIds,
  });

  @override
  Widget build(BuildContext context) {
    final l = chainIds.toList();
    l.sort(
      (a, b) => int.parse(a).compareTo(int.parse(b)),
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: StyleConstants.inputBorder,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          l.join(', '),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
