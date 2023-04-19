import 'package:flutter/material.dart';
import 'package:kadena_multisig/widgets/title_widget.dart';
import 'package:kadena_multisig/widgets/transaction_builder/transaction_builder.dart';

class TransactionBuilderPage extends StatelessWidget {
  static const gap = 16.0;

  const TransactionBuilderPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TransactionBuilder(index: 0);
  }
}
