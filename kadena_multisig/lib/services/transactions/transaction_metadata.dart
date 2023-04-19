import 'package:json_annotation/json_annotation.dart';

part 'transaction_metadata.g.dart';

@JsonSerializable(includeIfNull: false)
class TransactionMetadata {
  Set<String>? chainIds;
  bool? customUrl;
  String? nodeUrl;
  String? networkId;
  int? gasLimit;
  double? gasPrice;
  int? ttl;

  TransactionMetadata({
    this.chainIds = const {'1'},
    this.customUrl = false,
    this.nodeUrl = 'https://api.testnet.chainweb.com',
    this.networkId = 'testnet04',
    this.gasLimit = 15000,
    this.gasPrice = 1e-5,
    this.ttl = 86400,
  });

  TransactionMetadata copyWithOther({
    required TransactionMetadata other,
  }) {
    return TransactionMetadata(
      chainIds: other.chainIds ?? chainIds,
      customUrl: other.customUrl ?? customUrl,
      nodeUrl: other.nodeUrl ?? nodeUrl,
      networkId: other.networkId ?? networkId,
      gasLimit: other.gasLimit ?? gasLimit,
      gasPrice: other.gasPrice ?? gasPrice,
      ttl: other.ttl ?? ttl,
    );
  }

  TransactionMetadata copyWith({
    Set<String>? chainIds,
    bool? customUrl,
    String? nodeUrl,
    String? networkId,
    int? gasLimit,
    double? gasPrice,
    int? ttl,
  }) {
    return TransactionMetadata(
      chainIds: chainIds ?? this.chainIds,
      customUrl: customUrl ?? this.customUrl,
      nodeUrl: nodeUrl ?? this.nodeUrl,
      networkId: networkId ?? this.networkId,
      gasLimit: gasLimit ?? this.gasLimit,
      gasPrice: gasPrice ?? this.gasPrice,
      ttl: ttl ?? this.ttl,
    );
  }

  factory TransactionMetadata.fromJson(Map<String, dynamic> json) =>
      _$TransactionMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionMetadataToJson(this);

  @override
  String toString() {
    return 'TransactionMetadata{chainIds: $chainIds, nodeUrl: $nodeUrl, networkId: $networkId, gasLimit: $gasLimit, gasPrice: $gasPrice, ttl: $ttl}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionMetadata &&
          runtimeType == other.runtimeType &&
          chainIds == other.chainIds &&
          nodeUrl == other.nodeUrl &&
          networkId == other.networkId &&
          gasLimit == other.gasLimit &&
          gasPrice == other.gasPrice &&
          ttl == other.ttl;

  @override
  int get hashCode =>
      chainIds.hashCode ^
      nodeUrl.hashCode ^
      networkId.hashCode ^
      gasLimit.hashCode ^
      gasPrice.hashCode ^
      ttl.hashCode;
}
