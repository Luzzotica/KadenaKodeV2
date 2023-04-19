import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

abstract class IWalletConnectChain {
  Map<String, RequiredNamespace>? getRequiredNamespaces();
  Map<String, RequiredNamespace>? getOptionalNamespaces();
  Map<String, String>? getSessionProperties();
}
