class DartDefines {
  static const String nodeUrl = String.fromEnvironment(
    'NODE_URL',
    defaultValue: 'https://api.testnet.chainweb.com',
  );

  // WalletConnect information
  static const String projectId = String.fromEnvironment(
    'PROJECT_ID',
    defaultValue: '',
  );
  // static const String wcName = String.fromEnvironment(
  //   'WC_NAME',
  //   defaultValue: 'dApp',
  // );
  // static const String wcDesc = String.fromEnvironment(
  //   'WC_DESC',
  //   defaultValue: 'description',
  // );
  // static const String wcUrl = String.fromEnvironment(
  //   'WC_URL',
  //   defaultValue: 'url',
  // );
  // static const String wcIcon = String.fromEnvironment(
  //   'WC_ICON',
  //   defaultValue: 'icon',
  // );
}
