import 'package:equatable/equatable.dart';
import 'package:kadena_multisig/services/transactions/transaction_model.dart';

class TransactionsState extends Equatable {
  final int selectedIndex;
  final List<TransactionModel> transactions;

  const TransactionsState({
    this.selectedIndex = 0,
    required this.transactions,
  });

  @override
  List<Object> get props => [
        selectedIndex,
        transactions.fold<int>(0, (i, e) => i ^ e.hashCode),
      ];

  TransactionsState copyWith({
    int? selectedIndex,
    int? selectedSignerCapIndex,
    List<TransactionModel>? transactions,
  }) {
    return TransactionsState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      transactions: transactions ?? this.transactions,
    );
  }
}
