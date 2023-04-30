import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/wallet_connect/i_wallet_connect_chain.dart';
import 'package:kadena_multisig/services/kadena/models/pact_transaction_response.dart';
import 'package:kadena_multisig/services/kadena/i_kadena_service.dart';
import 'package:kadena_multisig/services/kadena/wallets/i_wallet_provider.dart';
import 'package:kadena_multisig/services/kadena/wallets/wallet_connect_provider.dart';
import 'package:kadena_multisig/services/wallet_connect/i_wallet_connect_service.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:provider/provider.dart';
import 'package:walletconnect_flutter_v2/apis/sign_api/models/proposal_models.dart';

class KadenaProvider
    with ChangeNotifier
    implements IKadenaService, IWalletConnectChain {
  @override
  IPactApiV1 pactApi = PactApiV1();

  String _nodeUrl = StringConstants.urlDefault;
  @override
  String get nodeUrl => pactApi.getNodeUrl() ?? _nodeUrl;

  String _networkId = StringConstants.networkIdDefault;
  @override
  String get networkId => pactApi.getNetworkId() ?? _networkId;

  @override
  String? account;

  @override
  List<PactTransactionResponse> transactions = [];

  @override
  IWalletProvider? walletProvider;

  KadenaProvider() {
    GetIt.I<IWalletConnectService>().registerChain(chain: this);
  }

  @override
  Future<void> setNodeUrl({
    required String nodeUrl,
  }) async {
    _nodeUrl = nodeUrl;
    await pactApi.setNodeUrl(nodeUrl: nodeUrl);

    notifyListeners();
  }

  @override
  void setNetworkId({
    required String networkId,
  }) {
    _networkId = networkId;
    pactApi.setNetworkId(networkId: networkId);

    notifyListeners();
  }

  @override
  Future<void> connect({required WalletProviderType providerType}) async {
    // Depending on the type provided, create a new instance of the wallet provider
    // and connect to it.
    if (providerType == WalletProviderType.walletConnect) {
      walletProvider = WalletConnectProvider();
    }

    List<String> accounts = await walletProvider!.connect();

    // If the provider is WalletConnect, get the accounts
    if (providerType == WalletProviderType.walletConnect) {
      final accounts = await walletProvider!.getAccounts(
        request: GetAccountsRequest(accounts: [
          AccountRequest(account: account!),
        ]),
      );
      account = accounts.accounts.first.account;
    } else {
      account = accounts.first;
    }

    notifyListeners();
  }

  @override
  Future<void> disconnect() async {
    await walletProvider!.disconnect();
    walletProvider = null;
    account = null;

    notifyListeners();
  }

  @override
  Future<PactResponse> local({
    required String code,
    required String chainId,
  }) {
    // TODO: implement local
    throw UnimplementedError();
  }

  @override
  Future<List<PactTransactionResponse>> localAndSend({
    required QuicksignRequest request,
  }) async {
    final List<PactTransactionResponse> responses = [];

    final QuicksignResult signed = await walletProvider!.quicksign(
      request: request,
    );

    if (signed.error != null) {
      throw Exception('Quicksign failed');
    }

    for (final response in signed.responses!) {
      if (response.outcome.result != QuicksignOutcome.success) {
        responses.add(
          PactTransactionResponse(
            message: response.outcome.msg,
          ),
        );
        continue;
      }

      final command = PactCommand(
        cmd: response.commandSigData.cmd,
        hash: response.outcome.hash!,
        sigs: response.commandSigData.sigs
            .map(
              (e) => Signer(
                sig: e.sig,
              ),
            )
            .toList(),
      );
      final localResult = await pactApi.local(
        command: command,
        preflight: true,
      );

      // If this local call failed, add the pact transaction response and go to the next command
      if (localResult.result.status != 'success') {
        responses.add(
          PactTransactionResponse(pactResult: localResult),
        );
        continue;
      }

      // Commit the TX to the blockchain
      final PactSendResponse sendResult = await pactApi.send(
        commands: PactSendRequest(
          cmds: [command],
        ),
      );

      // Add the response to the list of responses
      final tx = PactTransactionResponse(
        requestKey: sendResult.requestKeys.first,
      );
      responses.add(tx);
      transactions.add(tx);
      notifyListeners();
    }

    return responses;
  }

  @override
  Map<String, RequiredNamespace>? getRequiredNamespaces() {
    // final String chainId = 'kadena:${pactApi.getNetworkId()!}';
    return {
      'kadena': const RequiredNamespace(
        chains: ['kadena:mainnet01', 'kadena:testnet04'],
        methods: ['kadena_quicksign_v1', 'kadena_getAccounts_v1'],
        events: [],
      )
    };
  }

  @override
  Map<String, RequiredNamespace>? getOptionalNamespaces() {
    return null;
  }

  @override
  Map<String, String>? getSessionProperties() {
    return null;
  }
}
