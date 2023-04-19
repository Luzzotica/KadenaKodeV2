import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kadena_multisig/services/kadena/i_kadena_service.dart';
import 'package:kadena_multisig/services/kadena/kadena_provider.dart';
import 'package:kadena_multisig/services/settings/settings_bloc.dart';
import 'package:kadena_multisig/services/storage/i_storage_provider.dart';
import 'package:kadena_multisig/services/storage/storage_provider.dart';
import 'package:kadena_multisig/services/transactions/bloc/transaction_model_bloc.dart';
import 'package:kadena_multisig/services/transactions/service/i_transaction_builder_service.dart';
import 'package:kadena_multisig/services/transactions/service/transaction_builder_service.dart';
import 'package:kadena_multisig/services/wallet_connect/i_wallet_connect_service.dart';
import 'package:kadena_multisig/services/wallet_connect/wallet_connect_service.dart';
import 'package:kadena_multisig/utils/dart_defines.dart';
import 'package:kadena_multisig/utils/string_constants.dart';
import 'package:provider/provider.dart';
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

      return MultiProvider(
        providers: [
          ChangeNotifierProxyProvider0<IWalletConnectService>(
            create: (context) => WalletConnectService(context: context),
            update: (context, walletConnectService) {
              walletConnectService ??= WalletConnectService(context: context);
              walletConnectService.init(
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
              return walletConnectService;
            },
          ),
          ChangeNotifierProxyProvider<IWalletConnectService, IKadenaService>(
            create: (context) => KadenaProvider(
              context: context,
            ),
            update: (context, walletConnectService, kadenaService) {
              kadenaService ??= KadenaProvider(context: context);
              kadenaService.setNodeUrl(nodeUrl: DartDefines.nodeUrl);
              return kadenaService;
            },
          ),
          // ChangeNotifierProxyProvider0(
          //   create: (_) => SettingsProvider(),
          //   update: (context, settingsProvider) {
          //     settingsProvider ??= SettingsProvider();
          //     settingsProvider.init();
          //     return settingsProvider;
          //   },
          // ),
          // ChangeNotifierProxyProvider<SettingsProvider,
          //     TransactionMetadataProvider>(
          //   create: (context) => TransactionMetadataProvider(
          //     TransactionMetadata(),
          //   ),
          //   update: (context, storageProvider, settingsProvider) =>
          //       TransactionMetadataProvider(settingsProvider.metadata),
          // ),
          // ProxyProvider<TransactionMetadataProvider, void>(
          //   create: null,
          //   update: (context, transactionMetadataProvider, _) {
          //     transactionMetadataProvider.addListener(() {
          //       context.read<SettingsProvider>().saveMetadata();
          //     });
          //   },
          // ),
          // ChangeNotifierProxyProvider<SettingsProvider,
          //         TransactionMetadataProvider>(
          //     create: (_) => TransactionMetadataProvider()),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<SettingsBloc>(
              create: (context) => SettingsBloc(),
            ),
            BlocProvider<TransactionModelBloc>(
              create: (context) => TransactionModelBloc(),
            ),
          ],
          child: widget.child,
        ),
      );
    }));
  }
}
