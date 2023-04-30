import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:kadena_multisig/services/kadena/i_kadena_service.dart';
import 'package:kadena_multisig/services/kadena/kadena_provider.dart';
import 'package:kadena_multisig/services/settings/i_settings_service.dart';
import 'package:kadena_multisig/services/settings/settings_service.dart';
import 'package:kadena_multisig/services/storage/i_storage_provider.dart';
import 'package:kadena_multisig/services/storage/storage_provider.dart';
import 'package:kadena_multisig/services/transactions/service/i_transaction_builder_service.dart';
import 'package:kadena_multisig/services/transactions/service/transaction_builder_service.dart';
import 'package:kadena_multisig/services/wallet_connect/i_wallet_connect_service.dart';
import 'package:kadena_multisig/services/wallet_connect/wallet_connect_service.dart';
import 'package:kadena_multisig/utils/dart_defines.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

class DependencyWidget extends StatefulWidget {
  const DependencyWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<DependencyWidget> createState() => _DependencyWidgetState();
}

class _DependencyWidgetState extends State<DependencyWidget> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    GetIt.I.registerSingleton<IStorageProvider>(
      StorageProvider(
        prefs: await SharedPreferences.getInstance(),
      ),
    );

    final walletConnectService = WalletConnectService();
    await walletConnectService.init(
      projectId: DartDefines.projectId,
      metadata: const PairingMetadata(
        name: StringConstants.title,
        description: StringConstants.description,
        url: 'https://kadenakode.luzzotica.xyz',
        icons: [
          'https://kadena.io/favicon.ico',
        ],
      ),
    );
    GetIt.I.registerSingleton<IWalletConnectService>(
      walletConnectService,
    );

    final IKadenaService kadenaProvider = KadenaProvider();
    kadenaProvider.setNodeUrl(nodeUrl: DartDefines.nodeUrl);
    kadenaProvider.setNetworkId(networkId: DartDefines.nodeNetwork);
    GetIt.I.registerSingleton<IKadenaService>(kadenaProvider);

    GetIt.I.registerSingleton<ISettingsService>(SettingsService());

    GetIt.I.registerSingleton<ITransactionBuilderService>(
      TransactionBuilderService(),
    );

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: ((context, snapshot) {
      if (!_initialized) {
        return const Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ),
        );
      }

      return widget.child;
    }));
  }
}
