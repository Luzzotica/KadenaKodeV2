import 'package:flutter/src/foundation/change_notifier.dart';
import 'package:kadena_dart_sdk/models/pact_models.dart';
import 'package:kadena_multisig/services/transactions/service/i_transaction_builder_service.dart';
import 'package:kadena_multisig/services/transactions/transaction_model.dart';

class TransactionBuilderService extends ChangeNotifier
    implements ITransactionBuilderService {
  @override
  int selectedIndex = 0;

  @override
  List<TransactionModel> transactions = [
    TransactionModel.createEmpty(),
  ];

  @override
  void setSelectedIndex({required int index}) {
    selectedIndex = index;
    notifyListeners();
  }

  @override
  void addTransaction() {
    transactions = [
      ...transactions,
      TransactionModel.createEmpty(),
    ];
    notifyListeners();
  }

  @override
  void deleteTransactionAtIndex({required int index}) {
    transactions.removeAt(index);
    selectedIndex = index > selectedIndex ? selectedIndex : selectedIndex - 1;
    notifyListeners();
  }

  @override
  void updateTransactionAtIndex({
    required int index,
    required TransactionModel transactionModel,
  }) {
    transactions[index] = transactionModel;
    notifyListeners();
  }

  @override
  void updateSignerCapabilitiesInfoAtIndex({
    required int transactionIndex,
    required SignerCapabilitiesInfo info,
  }) {
    transactions[transactionIndex].signerCapabilitiesInfo = info;

    notifyListeners();
  }

  @override
  void addCapabilityAtIndex({
    required int transactionIndex,
    required int signerCapablitiesIndex,
  }) {
    transactions[transactionIndex]
        .signerCapabilitiesInfo
        .signerCapabilities[signerCapablitiesIndex]
        .clist = [
      ...transactions[transactionIndex]
              .signerCapabilitiesInfo
              .signerCapabilities[signerCapablitiesIndex]
              .clist ??
          [],
      Capability(name: ''),
    ];

    notifyListeners();
  }

  @override
  void updateCapabilityAtIndex({
    required int transactionIndex,
    required int signerCapablitiesIndex,
    required int capabilityIndex,
    required Capability capability,
  }) {
    transactions[transactionIndex]
        .signerCapabilitiesInfo
        .signerCapabilities[signerCapablitiesIndex]
        .clist![capabilityIndex] = capability;

    notifyListeners();
  }
}
