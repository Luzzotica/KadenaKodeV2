import 'package:flutter/material.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';

enum WalletProviderType {
  walletConnect,
}

abstract class IWalletProvider {
  /// Connect to the wallet provider. Returns the list of public keys or accounts
  /// that are available to the user.
  Future<List<String>> connect();

  /// Disconnect from the wallet provider.
  Future<void> disconnect({dynamic reason});

  /// Used with the
  Future<GetAccountsResponse> getAccounts({
    required GetAccountsRequest request,
    dynamic info,
  });
  Future<QuicksignResult> quicksign({
    required QuicksignRequest request,
    dynamic info,
  });
}
