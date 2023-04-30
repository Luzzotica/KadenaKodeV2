import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:kadena_multisig/widgets/code_input_widget.dart';

// ignore: depend_on_referenced_packages
import 'package:highlight/languages/lisp.dart';
import 'package:kadena_multisig/widgets/title_widget.dart';
import 'package:kadena_multisig/widgets/transaction_builder/capabilities/signer_capability_builder.dart';

class TransactionBuilder extends StatefulWidget {
  static const gap = 16.0;

  const TransactionBuilder({
    super.key,
    required this.index,
  });

  final int index;

  @override
  State<TransactionBuilder> createState() => _TransactionBuilderState();
}

class _TransactionBuilderState extends State<TransactionBuilder> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              SignerCapabilitiesBuilder(
                transactionIndex: widget.index,
              ),
              TitleWidget(
                title: StringConstants.envData,
                collapsible: true,
                child: CodeInputWidget(
                  codeController: CodeController(
                    language: lisp,
                  ),
                ),
              ),
              TitleWidget(
                title: StringConstants.code,
                collapsible: true,
                child: CodeInputWidget(
                  codeController: CodeController(
                    language: lisp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
