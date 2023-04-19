import 'package:equatable/equatable.dart';
import 'package:kadena_multisig/services/transactions/transaction_metadata.dart';

class SettingsState extends Equatable {
  final TransactionMetadata defaultMetadata;
  final bool isLoading;

  const SettingsState({required this.defaultMetadata, this.isLoading = false});

  @override
  List<Object> get props => [defaultMetadata, isLoading];

  SettingsState copyWith({
    TransactionMetadata? defaultMetadata,
    bool? isLoading,
  }) {
    return SettingsState(
      defaultMetadata: defaultMetadata ?? this.defaultMetadata,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
