import 'package:flutter/material.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/transactions/transaction_model.dart';

abstract class ITransactionBuilderService {
  abstract final int selectedIndex;
  abstract final List<TransactionModel> transactions;

  // Base Modifiers
  void setSelectedIndex({
    required int index,
  });
  void addTransaction();
  void deleteTransactionAtIndex({
    required int index,
  });
  void updateTransactionAtIndex({
    required int index,
    required TransactionModel transactionModel,
  });

  // SignerCapabilitiesInfo Modifiers
  void updateSignerCapabilitiesInfoAtIndex({
    required int transactionIndex,
    required SignerCapabilitiesInfo info,
  });

  // Capability Modifiers
  void addCapabilityAtIndex({
    required int transactionIndex,
    required int signerCapablitiesIndex,
  });
  void updateCapabilityAtIndex({
    required int transactionIndex,
    required int signerCapablitiesIndex,
    required int capabilityIndex,
    required Capability capability,
  });
}
