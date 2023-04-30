import 'package:kadena_dart_sdk/models/pact_models.dart';
import 'package:kadena_multisig/services/transactions/service/i_transaction_builder_service.dart';
import 'package:kadena_multisig/services/transactions/transaction_model.dart';

class TransactionBuilderService extends ITransactionBuilderService {
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
  void addSignerCapabilitiesAtIndex({
    required int transactionIndex,
  }) {
    transactions[transactionIndex].signerCapabilitiesInfo =
        transactions[transactionIndex].signerCapabilitiesInfo.copyWith(
      signerCapabilities: [
        ...transactions[transactionIndex]
            .signerCapabilitiesInfo
            .signerCapabilities,
        SignerCapabilities(
          pubKey: '',
        ),
      ],
    );

    notifyListeners();
  }

  @override
  void deleteSignerCapabilitiesAtIndex({
    required int transactionIndex,
    required int signerCapabilitiesIndex,
  }) {
    transactions[transactionIndex]
        .signerCapabilitiesInfo
        .signerCapabilities
        .removeAt(signerCapabilitiesIndex);
    final int selectedSignerIndex = transactions[transactionIndex]
        .signerCapabilitiesInfo
        .selectedSignerIndex;
    transactions[transactionIndex].signerCapabilitiesInfo.selectedSignerIndex =
        selectedSignerIndex > signerCapabilitiesIndex
            ? selectedSignerIndex - 1
            : selectedSignerIndex;

    notifyListeners();
  }

  @override
  void updateSignerCapabilitiesAtIndex({
    required int transactionIndex,
    required int signerCapabilitiesIndex,
    required SignerCapabilities signerCapabilities,
  }) {
    transactions[transactionIndex]
        .signerCapabilitiesInfo
        .signerCapabilities[signerCapabilitiesIndex] = signerCapabilities;

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
  void deleteCapabilityAtIndex({
    required int transactionIndex,
    required int signerCapabilitiesIndex,
    required int capabilityIndex,
  }) {
    transactions[transactionIndex]
        .signerCapabilitiesInfo
        .signerCapabilities[signerCapabilitiesIndex]
        .clist!
        .removeAt(capabilityIndex);

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
