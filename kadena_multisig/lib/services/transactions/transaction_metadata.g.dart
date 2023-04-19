// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionMetadata _$TransactionMetadataFromJson(Map<String, dynamic> json) =>
    TransactionMetadata(
      chainIds: (json['chainIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {'1'},
      customUrl: json['customUrl'] as bool? ?? false,
      nodeUrl: json['nodeUrl'] as String? ?? 'https://api.testnet.chainweb.com',
      networkId: json['networkId'] as String? ?? 'testnet04',
      gasLimit: json['gasLimit'] as int? ?? 15000,
      gasPrice: (json['gasPrice'] as num?)?.toDouble() ?? 1e-5,
      ttl: json['ttl'] as int? ?? 86400,
    );

Map<String, dynamic> _$TransactionMetadataToJson(TransactionMetadata instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('chainIds', instance.chainIds?.toList());
  writeNotNull('customUrl', instance.customUrl);
  writeNotNull('nodeUrl', instance.nodeUrl);
  writeNotNull('networkId', instance.networkId);
  writeNotNull('gasLimit', instance.gasLimit);
  writeNotNull('gasPrice', instance.gasPrice);
  writeNotNull('ttl', instance.ttl);
  return val;
}
