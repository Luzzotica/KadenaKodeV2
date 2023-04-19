import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/transactions/bloc/transaction_model_bloc.dart';
import 'package:kadena_multisig/services/transactions/bloc/transaction_model_event.dart';
import 'package:kadena_multisig/services/transactions/bloc/transaction_model_state.dart';
import 'package:kadena_multisig/services/transactions/service/i_transaction_builder_service.dart';
import 'package:kadena_multisig/services/transactions/transaction_model.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:kadena_multisig/widgets/custom_button_widget.dart';
import 'package:kadena_multisig/widgets/metadata/border_widget.dart';
import 'package:kadena_multisig/widgets/title_widget.dart';
import 'package:kadena_multisig/widgets/transaction_builder/capabilities/cap_extensions.dart';
import 'package:kadena_multisig/widgets/transaction_builder/capabilities/capability_builder.dart';
import 'package:kadena_multisig/widgets/transaction_builder/tabs/tab_selector.dart';

class SignerCapabilitiesBuilder extends StatefulWidget
    with GetItStatefulWidgetMixin {
  SignerCapabilitiesBuilder({
    super.key,
    required this.transactionIndex,
  });

  final int transactionIndex;

  @override
  State<SignerCapabilitiesBuilder> createState() =>
      _SignerCapabilitiesBuilderState();
}

class _SignerCapabilitiesBuilderState extends State<SignerCapabilitiesBuilder>
    with GetItStateMixin {
  final TextEditingController pubKeyController = TextEditingController();
  // SignerCapabilitiesInfo? _info;
  int selectedSignerIndex = 0;

  @override
  Widget build(BuildContext context) {
    watchOnly(
      (ITransactionBuilderService x) =>
          x.transactions[widget.transactionIndex].signerCapabilitiesInfo,
    );

    return TitleWidget(
      title: StringConstants.signerCapabilities,
      // actionTitle: StringConstants.addSigner,
      // action: _onAdd,
      child: BorderWidget(
        child: BlocSelector<TransactionModelBloc, TransactionsState,
            SignerCapabilitiesInfo>(
          selector: (state) => state
              .transactions[widget.transactionIndex].signerCapabilitiesInfo,
          builder: (context, state) {
            print('rebuilding signer capability builder');

            List<String> tabTitles = [];
            for (int i = 0; i < state.signerCapabilities.length; i++) {
              final pubKey = state.signerCapabilities[i].pubKey;

              tabTitles.add(pubKey.isEmpty ? StringConstants.empty : pubKey);
            }

            selectedSignerIndex = state.selectedSignerIndex;
            final List<SignerCapabilities> signerCapabilities =
                state.signerCapabilities;

            List<Widget> children = [];

            children.add(
              TabSelector(
                tabTitles: tabTitles,
                selectedIndex: state.selectedSignerIndex,
                onTabSelected: _onSignerCapTabSelected,
                onTabClose: _onSignerCapTabClose,
                onTabAdd: _onSignerCapAdd,
              ),
            );
            children.add(
              const SizedBox(height: 8),
            );

            if (signerCapabilities.isEmpty) {
              children.add(const Text('No Signers'));
            } else {
              if (signerCapabilities[selectedSignerIndex].pubKey !=
                  pubKeyController.text) {
                pubKeyController.text =
                    signerCapabilities[selectedSignerIndex].pubKey;
                // print(
                //     'updating pubKeyController.text: ${signerCapabilities[selectedSignerIndex].pubKey}');
              }

              children.addAll(
                [
                  SizedBox(
                    height: StyleConstants.inputHeight,
                    child: TitleWidget(
                      title: StringConstants.signerPublicKey,
                      child: Expanded(
                        child: TextFormField(
                          controller: pubKeyController,
                          expands: true,
                          maxLines: null,
                          onChanged: (value) {
                            _updateSignerCapPubKey(context);
                          },
                          decoration: const InputDecoration(
                            hintText: StringConstants.inputSignerPublicKeyHint,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCapabilitiesList(
                    selectedSignerIndex,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          type: CustomButtonType.primary,
                          onTap: _onAddCap,
                          child: const Text(
                            StringConstants.addCapability,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(children: children),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCapabilitiesList(int selectedSignerCapIndex) {
    return BlocSelector<TransactionModelBloc, TransactionsState,
        SignerCapabilities>(
      selector: (state) => state.transactions[widget.transactionIndex]
          .signerCapabilitiesInfo.signerCapabilities[selectedSignerCapIndex],
      builder: (context, state) {
        if (state.clist == null) {
          return const SizedBox.shrink();
        }

        List<Widget> capabilities = [];

        for (int i = 0; i < state.clist!.length; i++) {
          capabilities.add(
            CapabilityBuilder(
              transactionIndex: widget.transactionIndex,
              signerCapabilityIndex: selectedSignerIndex,
              capabilityIndex: i,
            ),
          );
          capabilities.add(const SizedBox(height: 8));
        }

        return Column(
          children: capabilities,
        );
      },
    );
  }

  void _updateSignerCapPubKey(BuildContext context) {
    final bloc = context.read<TransactionModelBloc>();

    final SignerCapabilitiesInfo signerCapability =
        bloc.state.transactions[widget.transactionIndex].signerCapabilitiesInfo;
    final List<SignerCapabilities> currentCaps = List.from(bloc
        .state
        .transactions[widget.transactionIndex]
        .signerCapabilitiesInfo
        .signerCapabilities);
    currentCaps[signerCapability.selectedSignerIndex] =
        currentCaps[signerCapability.selectedSignerIndex].copyWith(
      pubKey: pubKeyController.text,
    );
    final SignerCapabilitiesInfo info = bloc
        .state.transactions[widget.transactionIndex].signerCapabilitiesInfo
        .copyWith(
      signerCapabilities: currentCaps,
    );

    bloc.add(
      UpdateSignerCapabilitiesInfoAtIndex(
        transactionIndex: widget.transactionIndex,
        info: info,
      ),
    );
  }

  void _onSignerCapTabSelected(int index) {
    final bloc = context.read<TransactionModelBloc>();

    final SignerCapabilitiesInfo info = bloc
        .state.transactions[widget.transactionIndex].signerCapabilitiesInfo
        .copyWith(
      selectedSignerIndex: index,
    );

    bloc.add(
      UpdateSignerCapabilitiesInfoAtIndex(
        transactionIndex: widget.transactionIndex,
        info: info,
      ),
    );
  }

  void _onSignerCapTabClose(int index) {
    final bloc = context.read<TransactionModelBloc>();

    final SignerCapabilitiesInfo info = bloc
        .state.transactions[widget.transactionIndex].signerCapabilitiesInfo
        .removeAtIndex(
      index: index,
    );

    bloc.add(
      UpdateSignerCapabilitiesInfoAtIndex(
        transactionIndex: widget.transactionIndex,
        info: info,
      ),
    );
  }

  void _onSignerCapAdd() {
    final bloc = context.read<TransactionModelBloc>();

    final SignerCapabilitiesInfo info = bloc
        .state.transactions[widget.transactionIndex].signerCapabilitiesInfo
        .addEmptySigner();

    bloc.add(
      UpdateSignerCapabilitiesInfoAtIndex(
        transactionIndex: widget.transactionIndex,
        info: info,
      ),
    );
  }

  void _onAddCap() {
    final bloc = context.read<TransactionModelBloc>();

    final SignerCapabilitiesInfo info =
        bloc.state.transactions[widget.transactionIndex].signerCapabilitiesInfo;

    // Add a new cap to the list
    List<Capability> caps = [];
    if (info.signerCapabilities[info.selectedSignerIndex].clist != null) {
      caps = info.signerCapabilities[info.selectedSignerIndex].clist!;
    }
    caps.add(
      Capability(
        name: '',
      ),
    );

    // Create a new list of SignerCapabilities from the existing one, update the selected
    final List<SignerCapabilities> signerCaps =
        List.from(info.signerCapabilities);
    signerCaps[info.selectedSignerIndex] =
        signerCaps[info.selectedSignerIndex].copyWith(
      clist: caps,
    );

    final SignerCapabilitiesInfo newInfo = info.copyWith(
      signerCapabilities: signerCaps,
    );

    bloc.add(
      UpdateSignerCapabilitiesInfoAtIndex(
        transactionIndex: widget.transactionIndex,
        info: newInfo,
      ),
    );
  }
}
