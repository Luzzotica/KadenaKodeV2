import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/transactions/bloc/transaction_model_bloc.dart';
import 'package:kadena_multisig/services/transactions/bloc/transaction_model_event.dart';
import 'package:kadena_multisig/services/transactions/bloc/transaction_model_state.dart';
import 'package:kadena_multisig/services/transactions/transaction_model.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/widgets/title_widget.dart';
import 'package:kadena_multisig/widgets/transaction_builder/capabilities/cap_extensions.dart';

class CapabilityBuilder extends StatefulWidget {
  const CapabilityBuilder({
    super.key,
    required this.transactionIndex,
    required this.signerCapabilityIndex,
    required this.capabilityIndex,
  });

  final int transactionIndex;
  final int signerCapabilityIndex;
  final int capabilityIndex;

  @override
  State<CapabilityBuilder> createState() => _CapabilityBuilderState();
}

class _CapabilityBuilderState extends State<CapabilityBuilder> {
  final TextEditingController capNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          // color: StyleConstants.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
        color: StyleConstants.backgroundColorLighter,
      ),
      child: BlocSelector<TransactionModelBloc, TransactionsState, Capability>(
        selector: (state) => state
            .transactions[widget.transactionIndex]
            .signerCapabilitiesInfo
            .signerCapabilities[widget.signerCapabilityIndex]
            .clist![widget.capabilityIndex],
        builder: (context, state) {
          return Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: StyleConstants.inputHeight,
                  child: TitleWidget(
                    title: 'Name (full reference)',
                    child: Expanded(
                      child: TextFormField(
                        initialValue: state.name,
                        expands: true,
                        maxLines: null,
                        onChanged: _onNameChange,
                        decoration: const InputDecoration(
                          hintText: 'e.g. coin.GAS',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: SizedBox(
                  height: StyleConstants.inputHeight,
                  child: TitleWidget(
                    title: 'Args',
                    child: Expanded(
                      child: TextFormField(
                        initialValue: state.name,
                        expands: true,
                        maxLines: null,
                        onChanged: _onNameChange,
                        decoration: const InputDecoration(
                          hintText: 'e.g. coin.GAS',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _onNameChange(String name) {
    final bloc = context.read<TransactionModelBloc>();

    final Capability cap = bloc
        .state
        .transactions[widget.transactionIndex]
        .signerCapabilitiesInfo
        .signerCapabilities[widget.signerCapabilityIndex]
        .clist![widget.capabilityIndex]
        .copyWith(
      name: name,
    );

    bloc.add(
      UpdateCapabilityAtIndex(
        transactionIndex: widget.transactionIndex,
        signerCapabilityIndex: widget.signerCapabilityIndex,
        capabilityIndex: widget.capabilityIndex,
        capability: cap,
      ),
    );
  }
}
