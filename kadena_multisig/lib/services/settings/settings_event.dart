import 'package:equatable/equatable.dart';
import 'package:kadena_multisig/services/transactions/bloc/transaction_metadata_event.dart';
import 'package:kadena_multisig/services/transactions/transaction_metadata.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class UpdateSettings extends SettingsEvent
    implements UpdateTransactionMetadata {
  @override
  final TransactionMetadata metadata;

  const UpdateSettings({
    required this.metadata,
  });

  @override
  List<Object> get props => [metadata];
}
