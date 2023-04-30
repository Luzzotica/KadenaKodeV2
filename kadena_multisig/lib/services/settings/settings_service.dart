import 'package:flutter/material.dart';
import 'package:kadena_multisig/services/settings/i_settings_service.dart';
import 'package:kadena_multisig/services/transactions/transaction_metadata.dart';

class SettingsService extends ISettingsService {
  @override
  bool isLoading = false;

  @override
  TransactionMetadata defaultMetadata = TransactionMetadata();

  @override
  void updateDefaultMetadata({
    required TransactionMetadata metadata,
  }) {
    defaultMetadata = metadata;
    notifyListeners();
  }

  @override
  void updateIsLoading({
    required bool isLoading,
  }) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}
