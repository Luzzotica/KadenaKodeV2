import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/transactions/service/i_transaction_builder_service.dart';
import 'package:kadena_multisig/services/transactions/transaction_model.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:kadena_multisig/widgets/custom_button_widget.dart';
import 'package:kadena_multisig/widgets/border_widget.dart';
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
  int selectedSignerIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Get the data from our store
    final SignerCapabilitiesInfo state =
        watchOnly<ITransactionBuilderService, SignerCapabilitiesInfo>(
      (ITransactionBuilderService x) =>
          x.transactions[widget.transactionIndex].signerCapabilitiesInfo,
    );
    selectedSignerIndex = state.selectedSignerIndex;
    final String pubKey = watchOnly((ITransactionBuilderService x) {
      return state.signerCapabilities.isEmpty
          ? ''
          : x.transactions[widget.transactionIndex].signerCapabilitiesInfo
              .signerCapabilities[selectedSignerIndex].pubKey;
    });
    final List<Capability>? clist = watchOnly((ITransactionBuilderService x) {
      return state.signerCapabilities.isEmpty
          ? []
          : x.transactions[widget.transactionIndex].signerCapabilitiesInfo
              .signerCapabilities[selectedSignerIndex].clist;
    });

    // Keep our list of children
    List<Widget> children = [];

    // Create the titles for the tabs and add the tabs to the children
    List<String> tabTitles = [];
    for (int i = 0; i < state.signerCapabilities.length; i++) {
      final pubKey = state.signerCapabilities[i].pubKey;

      tabTitles.add(pubKey.isEmpty ? StringConstants.empty : pubKey);
    }

    children.add(
      TabSelector(
        tabTitles: tabTitles,
        selectedIndex: selectedSignerIndex,
        onTabSelected: (i) => _onSelectedSignerCapTab(i, state),
        onTabClose: _onCloseSignerCapTab,
        onTabAdd: _onAddSignerCap,
      ),
    );
    children.add(
      const SizedBox(height: 8),
    );

    // If we have signerCaps, get the current one and use it to build the rest of the UI
    if (state.signerCapabilities.isEmpty) {
      children.add(const Text(StringConstants.noSigners));
    } else {
      if (pubKey != pubKeyController.text) {
        pubKeyController.text = pubKey;
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
                    _updateSignerCapPubKey(
                      state.signerCapabilities[selectedSignerIndex],
                      value,
                    );
                  },
                  decoration: const InputDecoration(
                    hintText: StringConstants.inputSignerPublicKeyHint,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TitleWidget(
            title: StringConstants.capabilities,
            child: _buildCapabilitiesList(
              clist,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomButtonWidget(
                  type: CustomButtonType.primary,
                  onTap: () => _onAddCap(),
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

    return TitleWidget(
      title: StringConstants.signerCapabilities,
      // actionTitle: StringConstants.addSigner,
      // action: _onAdd,
      child: BorderWidget(
        backgroundColor: StyleConstants.backgroundColorDarkGray,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(children: children),
          ],
        ),
      ),
    );
  }

  Widget _buildCapabilitiesList(List<Capability>? clist) {
    if (clist == null || clist.isEmpty) {
      return const Center(
        child: Text(StringConstants.noCapabilities),
      );
    }

    List<Widget> capabilities = [];

    for (int i = 0; i < clist.length; i++) {
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
  }

  void _updateSignerCapPubKey(
    SignerCapabilities signerCapabilities,
    String newPubKey,
  ) {
    GetIt.I<ITransactionBuilderService>().updateSignerCapabilitiesAtIndex(
      transactionIndex: widget.transactionIndex,
      signerCapabilitiesIndex: selectedSignerIndex,
      signerCapabilities: signerCapabilities.copyWith(
        pubKey: newPubKey,
      ),
    );
  }

  void _onSelectedSignerCapTab(
    int index,
    SignerCapabilitiesInfo signerCapabilitiesInfo,
  ) {
    GetIt.I<ITransactionBuilderService>().updateSignerCapabilitiesInfoAtIndex(
      transactionIndex: widget.transactionIndex,
      info: signerCapabilitiesInfo.copyWith(
        selectedSignerIndex: index,
      ),
    );
  }

  void _onCloseSignerCapTab(int index) {
    GetIt.I<ITransactionBuilderService>().deleteSignerCapabilitiesAtIndex(
      transactionIndex: widget.transactionIndex,
      signerCapabilitiesIndex: index,
    );
  }

  void _onAddSignerCap() {
    GetIt.I<ITransactionBuilderService>().addSignerCapabilitiesAtIndex(
      transactionIndex: widget.transactionIndex,
    );
  }

  void _onAddCap() {
    GetIt.I<ITransactionBuilderService>().addCapabilityAtIndex(
      transactionIndex: widget.transactionIndex,
      signerCapablitiesIndex: selectedSignerIndex,
    );
  }
}
