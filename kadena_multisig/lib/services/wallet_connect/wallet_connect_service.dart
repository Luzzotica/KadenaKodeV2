import 'package:flutter/material.dart';
import 'package:kadena_multisig/services/wallet_connect/i_wallet_connect_chain.dart';
import 'package:kadena_multisig/services/wallet_connect/i_wallet_connect_service.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class WalletConnectService
    with ChangeNotifier
    implements IWalletConnectService {
  Map<String, RequiredNamespace> requiredNamespaces = {};
  Map<String, RequiredNamespace> optionalNamespaces = {};
  Map<String, String> sessionProperties = {};

  @override
  SignClient? signClient;

  WalletConnectService();

  @override
  Future<void> init({
    required String projectId,
    required PairingMetadata metadata,
  }) async {
    if (projectId == '') {
      return;
    }

    signClient = await SignClient.createInstance(
      projectId: projectId,
      metadata: metadata,
    );

    await signClient!.init();

    notifyListeners();
  }

  @override
  Future<SessionData> connect() async {
    // If there is a pairing that exists already, use it
    final List<PairingInfo> pairings = signClient!.pairings.getAll();
    final String? pairingTopic =
        pairings.isNotEmpty ? pairings.first.topic : null;

    final ConnectResponse response = await signClient!.connect(
      requiredNamespaces: requiredNamespaces,
      optionalNamespaces: optionalNamespaces,
      sessionProperties: sessionProperties,
      pairingTopic: pairingTopic,
    );

    return await response.session.future;
  }

  @override
  void registerChain({required IWalletConnectChain chain}) {
    requiredNamespaces.addAll(chain.getRequiredNamespaces() ?? {});
    optionalNamespaces.addAll(chain.getOptionalNamespaces() ?? {});
    sessionProperties.addAll(chain.getSessionProperties() ?? {});
  }
}
