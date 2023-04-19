import 'package:equatable/equatable.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/transactions/transaction_model.dart';

abstract class TransactionModelEvent extends Equatable {
  const TransactionModelEvent();

  @override
  List<Object> get props => [];
}

class AddTransaction extends TransactionModelEvent {
  final TransactionModel transactionModel;

  const AddTransaction({
    required this.transactionModel,
  });

  @override
  List<Object> get props => [
        transactionModel,
      ];
}

class UpdateTransactionAtIndex extends TransactionModelEvent {
  final int index;
  final TransactionModel transactionModel;

  const UpdateTransactionAtIndex({
    required this.index,
    required this.transactionModel,
  });

  @override
  List<Object> get props => [
        index,
        transactionModel,
      ];
}

class DeleteTransactionAtIndex extends TransactionModelEvent {
  final int index;

  const DeleteTransactionAtIndex({
    required this.index,
  });

  @override
  List<Object> get props => [
        index,
      ];
}

class UpdateSignerCapabilitiesInfoAtIndex extends TransactionModelEvent {
  final int transactionIndex;
  final SignerCapabilitiesInfo info;

  const UpdateSignerCapabilitiesInfoAtIndex({
    required this.transactionIndex,
    required this.info,
  });

  @override
  List<Object> get props => [
        transactionIndex,
        info,
      ];
}

class UpdateCapabilityAtIndex extends TransactionModelEvent {
  final int transactionIndex;
  final int signerCapabilityIndex;
  final int capabilityIndex;
  final Capability capability;

  const UpdateCapabilityAtIndex({
    required this.transactionIndex,
    required this.signerCapabilityIndex,
    required this.capabilityIndex,
    required this.capability,
  });

  @override
  List<Object> get props => [
        transactionIndex,
        signerCapabilityIndex,
        capabilityIndex,
        capability,
      ];
}
