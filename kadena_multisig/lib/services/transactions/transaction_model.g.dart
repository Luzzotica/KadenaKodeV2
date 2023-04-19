// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignerCapabilitiesInfo _$SignerCapabilitiesInfoFromJson(
        Map<String, dynamic> json) =>
    SignerCapabilitiesInfo(
      selectedSignerIndex: json['selectedSignerIndex'] as int? ?? 0,
      signerCapabilities: (json['signerCapabilities'] as List<dynamic>?)
              ?.map(
                  (e) => SignerCapabilities.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SignerCapabilitiesInfoToJson(
        SignerCapabilitiesInfo instance) =>
    <String, dynamic>{
      'selectedSignerIndex': instance.selectedSignerIndex,
      'signerCapabilities': instance.signerCapabilities,
    };

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      metadata: json['metadata'] == null
          ? null
          : TransactionMetadata.fromJson(
              json['metadata'] as Map<String, dynamic>),
      sender: json['sender'] as String?,
      signerCapabilitiesInfo: json['signerCapabilitiesInfo'] == null
          ? null
          : SignerCapabilitiesInfo.fromJson(
              json['signerCapabilitiesInfo'] as Map<String, dynamic>),
      transactionType: $enumDecodeNullable(
              _$TransactionTypeEnumMap, json['transactionType']) ??
          TransactionType.exec,
      data: json['data'] as Map<String, dynamic>? ?? const {},
      code: json['code'] as String?,
      pactId: json['pactId'] as String?,
      step: json['step'] as int?,
      rollback: json['rollback'] as bool?,
      proof: json['proof'] as String?,
      fromUntrustedSource: json['fromUntrustedSource'] as bool?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('metadata', instance.metadata);
  writeNotNull('sender', instance.sender);
  val['signerCapabilitiesInfo'] = instance.signerCapabilitiesInfo;
  val['transactionType'] = _$TransactionTypeEnumMap[instance.transactionType]!;
  writeNotNull('data', instance.data);
  writeNotNull('code', instance.code);
  writeNotNull('pactId', instance.pactId);
  writeNotNull('step', instance.step);
  writeNotNull('rollback', instance.rollback);
  writeNotNull('proof', instance.proof);
  writeNotNull('fromUntrustedSource', instance.fromUntrustedSource);
  return val;
}

const _$TransactionTypeEnumMap = {
  TransactionType.exec: 'exec',
  TransactionType.cont: 'cont',
};
