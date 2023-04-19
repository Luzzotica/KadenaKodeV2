import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kadena_multisig/services/kadena/i_kadena_service.dart';
import 'package:kadena_multisig/services/settings/settings_bloc.dart';
import 'package:kadena_multisig/services/settings/settings_event.dart';
import 'package:kadena_multisig/services/settings/settings_state.dart';
import 'package:kadena_multisig/services/transactions/transaction_metadata.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:kadena_multisig/widgets/metadata/border_widget.dart';
import 'package:kadena_multisig/widgets/metadata/chain_list_widget.dart';
import 'package:kadena_multisig/widgets/metadata/integer_input_widget.dart';
import 'package:kadena_multisig/widgets/metadata/decimal_input_widget.dart';
import 'package:kadena_multisig/widgets/metadata/network_selection_widget.dart';
import 'package:kadena_multisig/widgets/responsive_layout.dart';
import 'package:kadena_multisig/widgets/title_widget.dart';
import 'package:responsive_layout_grid/responsive_layout_grid.dart';

class SettingsPage extends StatelessWidget {
  static const gap = 16.0;

  SettingsPage({
    super.key,
  });

  final TextEditingController gasLimitController = TextEditingController();
  final TextEditingController gasPriceController = TextEditingController();
  final TextEditingController ttlController = TextEditingController();
  final TextEditingController networkController = TextEditingController();
  final TextEditingController networkIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(gap),
              child: Column(
                children: [
                  BorderWidget(
                    padding: 8,
                    child: ChainListWidget(
                      chainIds: state.defaultMetadata.chainIds!,
                      onChainIdsChanged: (chainIds) {
                        print('got here');
                        BlocProvider.of<SettingsBloc>(context).add(
                          UpdateSettings(
                            metadata: TransactionMetadata(
                              chainIds: chainIds,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: gap),
                  BorderWidget(
                    child: NetworkSelectionWidget(
                      network: state.defaultMetadata.nodeUrl!,
                      networkId: state.defaultMetadata.networkId!,
                      networkController: networkController,
                      networkIdController: networkIdController,
                      onNetworkChanged: (value) {
                        context.read<IKadenaService>().setNodeUrl(
                              nodeUrl: value,
                            );
                        BlocProvider.of<SettingsBloc>(context).add(
                          UpdateSettings(
                            metadata: TransactionMetadata(
                              nodeUrl: value,
                            ),
                          ),
                        );
                      },
                      onNetworkIdChanged: (value) {
                        context.read<IKadenaService>().setNetworkId(
                              networkId: value,
                            );
                        BlocProvider.of<SettingsBloc>(context).add(
                          UpdateSettings(
                            metadata: TransactionMetadata(
                              networkId: value,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: gap),
                  _buildGasAndTtlRow(context, state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGasAndTtlRow(
    BuildContext context,
    SettingsState state,
  ) {
    return ResponsiveLayoutGrid(
      children: [
        ResponsiveLayoutCell(
          position: CellPosition.nextRow(rowAlignment: RowAlignment.justify),
          columnSpan: ColumnSpan.range(min: 1, preferred: 3, max: 12),
          child: BorderWidget(
            child: SizedBox(
              height: StyleConstants.inputHeight,
              child: TitleWidget(
                title: StringConstants.inputGasLimit,
                child: Expanded(
                  child: IntegerInputWidget(
                    value: state.defaultMetadata.gasLimit!,
                    controller: gasLimitController,
                    onChanged: (value) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        UpdateSettings(
                          metadata: TransactionMetadata(
                            gasLimit: value,
                          ),
                        ),
                      );
                    },
                    hintText: StringConstants.inputGasLimitHint,
                  ),
                ),
              ),
            ),
          ),
        ),
        ResponsiveLayoutCell(
          columnSpan: ColumnSpan.range(min: 1, preferred: 3, max: 12),
          child: BorderWidget(
            child: SizedBox(
              height: StyleConstants.inputHeight,
              child: TitleWidget(
                title: StringConstants.inputGasPrice,
                child: Expanded(
                  child: DecimalInputWidget(
                    value: state.defaultMetadata.gasPrice!,
                    controller: gasPriceController,
                    onChanged: (value) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        UpdateSettings(
                          metadata: TransactionMetadata(
                            gasPrice: value,
                          ),
                        ),
                      );
                    },
                    hintText: StringConstants.inputGasPriceHint,
                  ),
                ),
              ),
            ),
          ),
        ),
        ResponsiveLayoutCell(
          columnSpan: ColumnSpan.range(min: 1, preferred: 3, max: 12),
          child: BorderWidget(
            child: SizedBox(
              height: StyleConstants.inputHeight,
              child: TitleWidget(
                title: StringConstants.inputTtl,
                child: Expanded(
                  child: IntegerInputWidget(
                    value: state.defaultMetadata.ttl!,
                    controller: ttlController,
                    onChanged: (value) {
                      BlocProvider.of<SettingsBloc>(context).add(
                        UpdateSettings(
                          metadata: TransactionMetadata(
                            ttl: value,
                          ),
                        ),
                      );
                    },
                    hintText: StringConstants.inputTtlHint,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
