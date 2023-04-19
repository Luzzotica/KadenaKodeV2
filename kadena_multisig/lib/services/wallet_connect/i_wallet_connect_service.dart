import 'package:flutter/material.dart';
import 'package:kadena_multisig/services/wallet_connect/i_wallet_connect_chain.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

abstract class IWalletConnectService with ChangeNotifier {
  abstract SignClient? signClient;

  Future<void> init({
    required String projectId,
    required PairingMetadata metadata,
  });

  Future<SessionData> connect();

  void registerChain({
    required IWalletConnectChain chain,
  });
}
