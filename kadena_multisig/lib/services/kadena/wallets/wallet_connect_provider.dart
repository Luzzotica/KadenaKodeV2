import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/kadena/wallets/i_wallet_provider.dart';
import 'package:kadena_multisig/services/wallet_connect/i_wallet_connect_service.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletConnectProvider implements IWalletProvider, Disposable {
  late ISignClient _signClient;

  @override
  Future<void> onDispose() async {}

  @override
  Future<List<String>> connect() async {
    SessionData session = await GetIt.I<IWalletConnectService>().connect();
    return session.namespaces.values.first.accounts
        .map(
          (e) => NamespaceUtils.getAccount(
            e,
          ),
        )
        .toList();
  }

  @override
  Future<void> disconnect({dynamic reason}) async {
    await _signClient.disconnect(
      topic: _signClient.pairings.getAll().first.topic,
      reason: WalletConnectError(
        code: -1,
        message: reason.toString(),
      ),
    );
  }

  @override
  Future<GetAccountsResponse> getAccounts({
    required GetAccountsRequest request,
    dynamic info,
  }) async {
    final activeSessions = _signClient.getActiveSessions();
    if (activeSessions.isNotEmpty) {
      final topic = activeSessions.keys.first;
      return await _signClient.request(
        topic: topic,
        chainId: 'kadena:$info',
        request: SessionRequestParams(
          method: 'kadena_getAccounts_v1',
          params: request,
        ),
      );
    } else {
      throw Exception('No active session available.');
    }
  }

  @override
  Future<QuicksignResult> quicksign({
    required QuicksignRequest request,
    dynamic info,
  }) async {
    final activeSessions = _signClient.getActiveSessions();
    if (activeSessions.isNotEmpty) {
      final topic = activeSessions.keys.first;
      return await _signClient.request(
        topic: topic,
        chainId: 'kadena:$info',
        request: SessionRequestParams(
          method: 'kadena_quicksign_v1',
          params: request,
        ),
      );
    } else {
      throw Exception('No active session available.');
    }
  }
}
