import 'package:equatable/equatable.dart';
import 'package:kadena_multisig/services/transactions/transaction_metadata.dart';

abstract class UpdateTransactionMetadata extends Equatable {
  abstract final TransactionMetadata metadata;
}
