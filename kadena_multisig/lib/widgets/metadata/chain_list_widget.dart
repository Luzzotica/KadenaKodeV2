import 'package:flutter/material.dart';
import 'package:kadena_multisig/utils/constants.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:kadena_multisig/widgets/metadata/chain_ids_list.dart';
import 'package:provider/provider.dart';

class ChainListWidget extends StatefulWidget {
  const ChainListWidget({
    super.key,
    required this.chainIds,
    required this.onChainIdsChanged,
  });

  final Set<String> chainIds;
  final void Function(Set<String>) onChainIdsChanged;

  @override
  ChainListWidgetState createState() => ChainListWidgetState();
}

class ChainListWidgetState extends State<ChainListWidget> {
  bool _isExpanded = true;

  final Set<String> chainList = Set.from(
    List.generate(20, (index) => '$index'),
  );

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  bool _hasAllSelected() {
    return chainList.union(widget.chainIds).length == widget.chainIds.length;
  }

  void _toggleAll() {
    if (_hasAllSelected()) {
      widget.onChainIdsChanged({chainList.first});
    } else {
      widget.onChainIdsChanged(chainList);
    }
  }

  void _selectChain(
    int index,
    Set<String> chainIds,
  ) {
    Set<String> newChainIds = Set.from(chainIds);
    chainIds.contains(index.toString())
        ? newChainIds.remove(index.toString())
        : newChainIds.add(index.toString());

    widget.onChainIdsChanged(newChainIds);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: _toggleExpanded,
          title: Container(
            padding: const EdgeInsets.only(
              bottom: 8,
            ),
            child: Text(
              StringConstants.chainIdsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          subtitle: ChainIdsList(
            chainIds: widget.chainIds,
          ),
          trailing: Icon(
            _isExpanded ? Icons.close : Icons.arrow_drop_down_circle_outlined,
            color: StyleConstants.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        if (_isExpanded) _buildChainGrid(),
      ],
    );
  }

  Widget _buildChainGrid() {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: List.generate(chainList.length + 1, (index) {
        final String sIndex = index.toString();
        final bool selected = widget.chainIds.contains(sIndex);
        String name = sIndex;
        if (index == chainList.length) {
          name = _hasAllSelected()
              ? StringConstants.deselectAll
              : StringConstants.selectAll;
        }
        return InkWell(
          onTap: () {
            index == chainList.length
                ? _toggleAll()
                : _selectChain(index, widget.chainIds);
          },
          child: Container(
            decoration: BoxDecoration(
              color: selected ? StyleConstants.primaryColor : Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              name,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }
}
