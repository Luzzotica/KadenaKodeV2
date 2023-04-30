import 'package:kadena_multisig/services/settings/i_settings_service.dart';
import 'package:kadena_multisig/services/transactions/transaction_metadata.dart';

class SettingsService extends ISettingsService {
  @override
  bool isLoading = false;

  @override
  TransactionMetadata defaultMetadata = TransactionMetadata();

  @override
  void updateDefaultMetadata({
    Set<String>? chainIds,
    bool? customUrl,
    String? nodeUrl,
    String? networkId,
    int? gasLimit,
    double? gasPrice,
    int? ttl,
  }) {
    defaultMetadata = defaultMetadata.copyWith(
      chainIds: chainIds,
      customUrl: customUrl,
      nodeUrl: nodeUrl,
      networkId: networkId,
      gasLimit: gasLimit,
      gasPrice: gasPrice,
      ttl: ttl,
    );
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
