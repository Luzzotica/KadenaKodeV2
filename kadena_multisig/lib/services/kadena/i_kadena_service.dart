import 'package:flutter/material.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/kadena/models/pact_transaction_response.dart';
import 'package:kadena_multisig/services/kadena/wallets/i_wallet_provider.dart';

abstract class IKadenaService with ChangeNotifier {
  /// Initializes the kadena service with the given node url.
  /// This will initialize the pact api and fetch the network id of the node.
  /// Example [nodeUrl] -> https://api.chainweb.com
  Future<void> setNodeUrl({
    required String nodeUrl,
  });

  /// Sets the network id of the kadena service, if it wasn't set by [setNodeUrl]
  void setNetworkId({required String networkId});

  /// The pact api used to interact with the kadena network
  abstract IPactApiV1 pactApi;

  /// The URL of the node the pact api will send requests to.
  /// When you set this, it will update the pactApi with the new url.
  /// Example [nodeUrl] -> https://api.chainweb.com
  abstract final String nodeUrl;

  /// Returns the network id of the connected node.
  /// Used to construct PactCommands outside of the KadenaService.
  /// Returns null if the kadena service hasn't been initialized.
  abstract final String networkId;

  /// Returns the network id of the connected node.
  /// Generally retrieved from the pact api.
  // String getNetworkId();

  /// The list of transactions that have been sent to and received from the pact api.
  abstract List<PactTransactionResponse> transactions;

  /// The wallet that is currently connected to the kadena service.
  /// This will be null if no wallet is connected.
  /// Options: [WalletConnectProvider]
  abstract IWalletProvider? walletProvider;

  /// The account that was retrieved from the connected wallet.
  abstract String? account;

  /// Connects to a wallet of the given type.
  Future<void> connect({
    required WalletProviderType providerType,
  });

  /// Disconnects from the currently connected wallet.
  /// This will also clear the account.
  /// This will not clear the transactions, nor node url.
  ///
  /// If the wallet is not connected, this will do nothing.
  Future<void> disconnect();

  /// Runs the code dirtily on the node.
  /// Used to read information from the blockchain. This will not commit anything to the chain.
  Future<PactResponse> local({
    required String code,
    required String chainId,
  });

  /// Signs a QuicksignRequest with the connected wallet.
  /// Tests each transaction locally using [PactApiV1.local] and if the local call succeeds,
  /// then it commits the [PactCommand] to the blockchain using [PactApiV1.send].
  Future<List<PactTransactionResponse>> localAndSend({
    required QuicksignRequest request,
  });
}
