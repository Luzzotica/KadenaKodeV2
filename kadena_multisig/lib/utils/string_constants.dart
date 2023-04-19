class StringConstants {
  static const title = 'KadenaKode';
  static const description =
      'A tool used to build Kadena Pact commands and sign them.';

  // Pages
  static const txBuilderPage = 'Transaction Builder';
  static const txBuilderPageIcon = 'TX Builder';
  static const txMetadataPage = 'Transaction Metadata';
  static const txMetadataPageIcon = 'Metadata';
  static const multisigPageIcon = 'Multisig';
  static const multisigPage = 'Multisig';

  // Transaction Builder
  static const String chainIdsTitle = 'Chains Ids:';
  static const String selectAll = 'Select All';
  static const String deselectAll = 'Deselect All';
  static const String inputNetworkUrl = 'Network Url';
  static const String inputNetworkUrlHint = 'Enter Kadena Node Url';
  static const String inputNetworkIdHint = 'Enter Kadena Network ID';
  static const String inputGasLimitHint = 'Enter Gas Limit';
  static const String inputGasPriceHint = 'Enter Gas Price';
  static const String useCustomUrl = 'Use custom URL';
  static const String useCustomNetworkId = 'Use custom Network Id';
  static const String inputGasPrice = 'Gas Price:';
  static const String inputGasLimit = 'Gas Limit:';
  static const String inputTtl = 'TTL:';
  static const String inputTtlHint = 'Enter the Time To Live';
  static const String code = 'Code:';
  static const String envData = 'Env Data:';

  // Signer Capability Builder

  static const String signerCapabilities = 'Signer Capabilities';
  static const String addSigner = 'Add Signer';
  static const String empty = 'Empty';
  static const String addCapability = 'Add Capability';
  static const String signerPublicKey = 'Signer Public Key:';
  static const String inputSignerPublicKeyHint = 'Enter Signer Public Key';

  // Network Selection
  static const String urlDefault = 'https://api.testnet.chainweb.com';
  static const String networkIdDefault = 'testnet04';
  static const List<String> urls = [
    'https://api.chainweb.com',
    'https://api.testnet.chainweb.com',
  ];
  static const Map<String, String> urlToNetworkId = {
    'https://api.chainweb.com': 'mainnet01',
    'https://api.testnet.chainweb.com': 'testnet04',
  };

  // Misc
  static const copyToClipboard = 'Copy to Clipboard';
  static const copiedToClipboard = 'QR code content copied!';
}
