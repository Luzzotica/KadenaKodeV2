import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';

extension SignerCapabilitiesExtension on SignerCapabilities {
  SignerCapabilities copyWith({
    String? pubKey,
    List<Capability>? clist,
  }) {
    return SignerCapabilities(
      pubKey: pubKey ?? this.pubKey,
      clist: clist ?? this.clist,
    );
  }
}

extension CapabilityExtension on Capability {
  Capability copyWith({
    String? name,
    List<dynamic>? args,
  }) {
    return Capability(
      name: name ?? this.name,
      args: args ?? this.args,
    );
  }
}
