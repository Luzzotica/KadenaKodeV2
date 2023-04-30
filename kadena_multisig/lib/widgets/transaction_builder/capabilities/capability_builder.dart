import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/transactions/service/i_transaction_builder_service.dart';
import 'package:kadena_multisig/services/transactions/transaction_model.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:kadena_multisig/widgets/custom_button_widget.dart';
import 'package:kadena_multisig/widgets/title_widget.dart';
import 'package:kadena_multisig/widgets/transaction_builder/capabilities/cap_extensions.dart';

class CapabilityBuilder extends StatefulWidget with GetItStatefulWidgetMixin {
  CapabilityBuilder({
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

class _CapabilityBuilderState extends State<CapabilityBuilder>
    with GetItStateMixin {
  final TextEditingController capNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Capability? state =
        watchOnly<ITransactionBuilderService, Capability?>(
            (ITransactionBuilderService x) {
      // Check all of the indexes to make sure they are valid
      if (x.transactions.length <= widget.transactionIndex) {
        return null;
      }
      final SignerCapabilitiesInfo signerInfo =
          x.transactions[widget.transactionIndex].signerCapabilitiesInfo;
      if (signerInfo.signerCapabilities.length <=
          widget.signerCapabilityIndex) {
        return null;
      }
      final List<Capability>? clist =
          signerInfo.signerCapabilities[widget.signerCapabilityIndex].clist;
      if (clist == null || clist.length <= widget.capabilityIndex) {
        return null;
      }

      return clist[widget.capabilityIndex];
    });

    if (state == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // border: Border.all(
        //   color: StyleConstants.backgroundColorLighter,
        //   width: 1.0,
        // ),
        borderRadius: BorderRadius.circular(8.0),
        color: StyleConstants.backgroundColorLighter,
      ),
      constraints: const BoxConstraints(
        maxHeight: StyleConstants.inputHeight + 16,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: StyleConstants.inputHeight,
              child: TitleWidget(
                title: StringConstants.capabilityName,
                titleStyle: Theme.of(context).textTheme.titleMedium,
                child: Expanded(
                  child: TextFormField(
                    initialValue: state.name,
                    expands: true,
                    maxLines: null,
                    onChanged: (value) => _onNameChange(state, value),
                    decoration: const InputDecoration(
                      hintText: StringConstants.capabilityNameHint,
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
                title: StringConstants.capabilityArgs,
                titleStyle: Theme.of(context).textTheme.titleMedium,
                child: Expanded(
                  child: TextFormField(
                    initialValue: state.name,
                    expands: true,
                    maxLines: null,
                    onChanged: (value) => _onNameChange(state, value),
                    decoration: const InputDecoration(
                      hintText: StringConstants.capabilityArgsHint,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SizedBox(
              //   width: 40,
              //   height: 90.0,
              Expanded(
                child: CustomButtonWidget(
                  type: CustomButtonType.failure,
                  padding: 2,
                  onTap: _onDelete,
                  child: const Icon(Icons.delete_forever),
                ),
              ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  void _onNameChange(Capability cap, String name) {
    GetIt.I<ITransactionBuilderService>().updateCapabilityAtIndex(
      transactionIndex: widget.transactionIndex,
      signerCapablitiesIndex: widget.signerCapabilityIndex,
      capabilityIndex: widget.capabilityIndex,
      capability: cap.copyWith(name: name),
    );
  }

  void _onDelete() {
    GetIt.I<ITransactionBuilderService>().deleteCapabilityAtIndex(
      transactionIndex: widget.transactionIndex,
      signerCapabilitiesIndex: widget.signerCapabilityIndex,
      capabilityIndex: widget.capabilityIndex,
    );
  }
}
