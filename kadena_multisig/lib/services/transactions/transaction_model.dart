import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/transactions/transaction_metadata.dart';

part 'transaction_model.g.dart';

enum TransactionType {
  exec,
  cont,
}

@JsonSerializable(includeIfNull: false)
class SignerCapabilitiesInfo {
  int selectedSignerIndex;
  List<SignerCapabilities> signerCapabilities;

  SignerCapabilitiesInfo({
    this.selectedSignerIndex = 0,
    this.signerCapabilities = const [],
  });

  factory SignerCapabilitiesInfo.fromJson(Map<String, dynamic> json) =>
      _$SignerCapabilitiesInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SignerCapabilitiesInfoToJson(this);

  SignerCapabilitiesInfo copyWith({
    int? selectedSignerIndex,
    List<SignerCapabilities>? signerCapabilities,
  }) {
    return SignerCapabilitiesInfo(
      selectedSignerIndex: selectedSignerIndex ?? this.selectedSignerIndex,
      signerCapabilities: signerCapabilities ?? this.signerCapabilities,
    );
  }

  SignerCapabilitiesInfo copyWithOther({
    required SignerCapabilitiesInfo other,
  }) {
    return SignerCapabilitiesInfo(
      selectedSignerIndex: other.selectedSignerIndex,
      signerCapabilities: other.signerCapabilities,
    );
  }

  SignerCapabilitiesInfo addEmptySigner() {
    return SignerCapabilitiesInfo(
      selectedSignerIndex: signerCapabilities.length,
      signerCapabilities: List.from(signerCapabilities)
        ..add(SignerCapabilities(pubKey: '', clist: [])),
    );
  }

  // SignerCapabilitiesInfo addCapability({
  //   required int index,
  //   required Capability capability,
  // }) {
  //   return SignerCapabilitiesInfo(
  //     selectedSignerIndex: signerCapabilities.length,
  //     signerCapabilities: List.from(signerCapabilities)
  //       ..add(SignerCapabilities(pubKey: pubKey, clist: clist)),
  //   );
  // }

  SignerCapabilitiesInfo removeAtIndex({
    int? index,
  }) {
    final List<SignerCapabilities> newSignerCapabilities = List.from(
      signerCapabilities,
    )..removeAt(index ?? selectedSignerIndex);
    return SignerCapabilitiesInfo(
      selectedSignerIndex:
          selectedSignerIndex == 0 ? 0 : selectedSignerIndex - 1,
      signerCapabilities: newSignerCapabilities,
    );
  }

  @override
  String toString() {
    return 'SignerCapabilitiesInfo{selectedSignerCapIndex: $selectedSignerIndex, signerCapabilities: $signerCapabilities}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignerCapabilitiesInfo &&
          runtimeType == other.runtimeType &&
          selectedSignerIndex == other.selectedSignerIndex &&
          signerCapabilities == other.signerCapabilities;

  @override
  int get hashCode =>
      selectedSignerIndex.hashCode ^
      signerCapabilities.fold(0, (i, e) => i ^ e.hashCode);
}

@JsonSerializable(includeIfNull: false)
class TransactionModel extends ChangeNotifier {
  // Transaction Metadata
  TransactionMetadata? metadata;
  String? sender;

  // Transaction Signers
  SignerCapabilitiesInfo signerCapabilitiesInfo;

  // Message Info
  TransactionType transactionType = TransactionType.exec;
  Map<String, dynamic>? data;

  // exec pact code
  String? code;

  // cont information
  String? pactId;
  int? step;
  bool? rollback;
  String? proof;

  // misc
  bool? fromUntrustedSource;

  TransactionModel({
    this.metadata,
    this.sender,
    SignerCapabilitiesInfo? signerCapabilitiesInfo,
    this.transactionType = TransactionType.exec,
    this.data = const {},
    this.code,
    this.pactId,
    this.step,
    this.rollback,
    this.proof,
    this.fromUntrustedSource,
  }) : signerCapabilitiesInfo =
            signerCapabilitiesInfo ?? SignerCapabilitiesInfo();

  factory TransactionModel.createEmpty() {
    return TransactionModel();
  }

  TransactionModel copyWithOther({
    required TransactionModel other,
  }) {
    return TransactionModel(
      metadata: other.metadata ?? metadata,
      sender: other.sender ?? sender,
      signerCapabilitiesInfo: other.signerCapabilitiesInfo,
      transactionType: other.transactionType,
      data: other.data ?? data,
      code: other.code ?? code,
      pactId: other.pactId ?? pactId,
      step: other.step ?? step,
      rollback: other.rollback ?? rollback,
      proof: other.proof ?? proof,
      fromUntrustedSource: other.fromUntrustedSource ?? fromUntrustedSource,
    );
  }

  TransactionModel copyWith({
    TransactionMetadata? metadata,
    String? sender,
    SignerCapabilitiesInfo? signerCapabilitiesInfo,
    TransactionType? transactionType,
    Map<String, dynamic>? data,
    String? code,
    String? pactId,
    int? step,
    bool? rollback,
    String? proof,
    bool? fromUntrustedSource,
  }) {
    return TransactionModel(
      metadata: metadata ?? this.metadata,
      sender: sender ?? this.sender,
      signerCapabilitiesInfo:
          signerCapabilitiesInfo ?? this.signerCapabilitiesInfo,
      transactionType: transactionType ?? this.transactionType,
      data: data ?? this.data,
      code: code ?? this.code,
      pactId: pactId ?? this.pactId,
      step: step ?? this.step,
      rollback: rollback ?? this.rollback,
      proof: proof ?? this.proof,
      fromUntrustedSource: fromUntrustedSource ?? this.fromUntrustedSource,
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  @override
  String toString() {
    return 'TransactionModel{metadata: $metadata, sender: $sender, signerCapabilitiesInfo: $signerCapabilitiesInfo, transactionType: $transactionType, data: $data, code: $code, pactId: $pactId, step: $step, rollback: $rollback, proof: $proof, fromUntrustedSource: $fromUntrustedSource}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModel &&
          runtimeType == other.runtimeType &&
          metadata == other.metadata &&
          sender == other.sender &&
          signerCapabilitiesInfo == other.signerCapabilitiesInfo &&
          transactionType == other.transactionType &&
          data == other.data &&
          code == other.code &&
          pactId == other.pactId &&
          step == other.step &&
          rollback == other.rollback &&
          proof == other.proof &&
          fromUntrustedSource == other.fromUntrustedSource;

  @override
  int get hashCode =>
      metadata.hashCode ^
      sender.hashCode ^
      signerCapabilitiesInfo.hashCode ^
      transactionType.hashCode ^
      data.hashCode ^
      code.hashCode ^
      pactId.hashCode ^
      step.hashCode ^
      rollback.hashCode ^
      proof.hashCode ^
      fromUntrustedSource.hashCode;
}
