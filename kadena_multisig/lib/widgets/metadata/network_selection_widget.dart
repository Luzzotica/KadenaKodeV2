import 'package:flutter/material.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:kadena_multisig/widgets/title_widget.dart';
import 'package:responsive_layout_grid/responsive_layout_grid.dart';

class NetworkSelectionWidget extends StatefulWidget {
  const NetworkSelectionWidget({
    super.key,
    required this.network,
    required this.networkId,
    required this.networkController,
    required this.networkIdController,
    required this.onNetworkChanged,
    required this.onNetworkIdChanged,
  });

  final String network;
  final String networkId;
  final TextEditingController networkController;
  final TextEditingController networkIdController;
  final void Function(String) onNetworkChanged;
  final void Function(String) onNetworkIdChanged;

  @override
  State<NetworkSelectionWidget> createState() => _NetworkSelectionWidgetState();
}

class _NetworkSelectionWidgetState extends State<NetworkSelectionWidget> {
  bool _isCustomUrlEnabled = false;

  void _setNodeAndNetwork(String url) {
    widget.onNetworkChanged(url);
    widget.onNetworkIdChanged(
      StringConstants.urlToNetworkId[url] ??
          StringConstants.urlToNetworkId.values.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.networkController.text.isEmpty) {
      widget.networkController.text = widget.network;
    }
    if (widget.networkIdController.text.isEmpty || !_isCustomUrlEnabled) {
      widget.networkIdController.text = widget.networkId;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveLayoutGrid(
          minimumColumnWidth: 300,
          // maxNumberOfColumns: 2,
          children: [
            ResponsiveLayoutCell(
              position:
                  CellPosition.nextRow(rowAlignment: RowAlignment.justify),
              columnSpan: ColumnSpan.range(min: 1, preferred: 1, max: 12),
              child: SizedBox(
                height: StyleConstants.inputHeight,
                child: TitleWidget(
                  title: 'Network:',
                  child: Expanded(
                    child: _isCustomUrlEnabled
                        ? _customUrlInput()
                        : _urlDropdown(),
                  ),
                ),
              ),
            ),
            ResponsiveLayoutCell(
              child: SizedBox(
                height: StyleConstants.inputHeight,
                child: TitleWidget(
                  title: 'Network ID:',
                  child: Expanded(
                    child: _networkIdInput(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _customUrlCheckbox(),
      ],
    );
  }

  Widget _urlDropdown() {
    return DropdownButtonFormField<String>(
      value: StringConstants.urls.contains(widget.network)
          ? widget.network
          : StringConstants.urlDefault,
      borderRadius: BorderRadius.circular(8),
      icon: const Icon(
        Icons.arrow_drop_down_circle_outlined,
        color: StyleConstants.primaryColor,
        size: 24,
      ),
      onChanged: (String? newValue) {
        _setNodeAndNetwork(newValue!);
      },
      items: StringConstants.urls.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _customUrlInput() {
    return TextFormField(
      controller: widget.networkController,
      expands: true,
      maxLines: null,
      onChanged: widget.onNetworkChanged,
      decoration: const InputDecoration(
        // labelText: StringConstants.inputNetworkUrl,
        hintText: StringConstants.inputNetworkUrlHint,
      ),
    );
  }

  Widget _networkIdInput() {
    // if (_isCustomUrlEnabled) {
    return TextFormField(
      controller: widget.networkIdController,
      expands: true,
      maxLines: null,
      readOnly: !_isCustomUrlEnabled,
      onChanged: widget.onNetworkIdChanged,
      decoration: const InputDecoration(
        hintText: StringConstants.inputNetworkIdHint,
      ),
    );
    // } else {
    //   return Container(
    //     padding: const EdgeInsets.symmetric(
    //       horizontal: 11,
    //     ),
    //     decoration: StyleConstants.inputBorder,
    //     child: Align(
    //       alignment: Alignment.centerLeft,
    //       child: Text(
    //         _kadenaService.networkId,
    //         style: Theme.of(context).textTheme.titleMedium,
    //       ),
    //     ),
    //   );
    // }
  }

  Widget _customUrlCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _isCustomUrlEnabled,
          onChanged: (bool? newValue) {
            // If the new value is false, we need to set the node url to the
            // default value.
            if (!newValue!) {
              _setNodeAndNetwork(StringConstants.urlDefault);
            }
            setState(() {
              _isCustomUrlEnabled = newValue;
            });
          },
        ),
        const Text(StringConstants.useCustomUrl),
      ],
    );
  }
}
