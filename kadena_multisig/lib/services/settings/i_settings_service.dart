import 'package:flutter/material.dart';
import 'package:kadena_multisig/services/transactions/transaction_metadata.dart';

abstract class ISettingsService extends ChangeNotifier {
  abstract final bool isLoading;
  abstract final TransactionMetadata defaultMetadata;

  /// Updates the default metadata
  void updateDefaultMetadata({
    required TransactionMetadata metadata,
  });

  /// Updates the isLoading state
  void updateIsLoading({
    required bool isLoading,
  });
}
