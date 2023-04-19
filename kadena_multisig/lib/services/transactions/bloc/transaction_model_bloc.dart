import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kadena_dart_sdk/kadena_dart_sdk.dart';
import 'package:kadena_multisig/services/transactions/bloc/transaction_model_event.dart';
import 'package:kadena_multisig/services/transactions/bloc/transaction_model_state.dart';
import 'package:kadena_multisig/services/transactions/transaction_model.dart';
import 'package:kadena_multisig/widgets/transaction_builder/capabilities/cap_extensions.dart';

class TransactionModelBloc
    extends Bloc<TransactionModelEvent, TransactionsState> {
  TransactionModelBloc()
      : super(
          TransactionsState(
            transactions: [
              TransactionModel.createEmpty(),
            ],
          ),
        ) {
    on<AddTransaction>(_add);
    on<UpdateTransactionAtIndex>(_update);
    on<DeleteTransactionAtIndex>(_delete);

    on<UpdateSignerCapabilitiesInfoAtIndex>(_updateSignerCapabilitiesInfo);
    on<UpdateCapabilityAtIndex>(_updateCapabilityAtIndex);
  }

  void _add(
    AddTransaction event,
    Emitter<TransactionsState> emit,
  ) {
    final List<TransactionModel> currentMetadata = List.from(
      state.transactions,
    );
    currentMetadata.add(event.transactionModel);

    emit(state.copyWith(transactions: currentMetadata));
  }

  void _update(
    UpdateTransactionAtIndex event,
    Emitter<TransactionsState> emit,
  ) {
    // final List<TransactionModel> newMetadata = List.from(state.transactions);
    // newMetadata[event.index] = state.transactions[event.index].copyWithOther(
    //   other: event.transactionModel,
    // );

    // print(newMetadata);

    emit(
      state.copyWith(
        transactions: updateTransactionAtIndex(
          event.index,
          event.transactionModel,
        ),
      ),
    );
  }

  void _delete(
    DeleteTransactionAtIndex event,
    Emitter<TransactionsState> emit,
  ) {
    final List<TransactionModel> currentMetadata = List.from(
      state.transactions,
    );
    currentMetadata.removeAt(event.index);

    emit(
      state.copyWith(
        transactions: currentMetadata,
        selectedIndex: event.index > state.selectedIndex
            ? state.selectedIndex
            : state.selectedIndex - 1,
      ),
    );
  }

  void _updateSignerCapabilitiesInfo(
    UpdateSignerCapabilitiesInfoAtIndex event,
    Emitter<TransactionsState> emit,
  ) {
    final TransactionModel model =
        state.transactions[event.transactionIndex].copyWith(
      signerCapabilitiesInfo: event.info,
    );

    print(
      state
          .copyWith(
            transactions: updateTransactionAtIndex(
              event.transactionIndex,
              model,
            ),
          )
          .transactions,
    );

    emit(
      state.copyWith(
        transactions: updateTransactionAtIndex(
          event.transactionIndex,
          model,
        ),
      ),
    );
  }

  void _updateCapabilityAtIndex(
    UpdateCapabilityAtIndex event,
    Emitter<TransactionsState> emit,
  ) {
    final List<Capability>? caps = state.transactions[event.transactionIndex]
        .signerCapabilitiesInfo.signerCapabilities[event.capabilityIndex].clist;

    if (caps == null) {
      return;
    }

    final List<Capability> newCaps = List.from(caps);
    newCaps[event.capabilityIndex] = event.capability;

    final SignerCapabilities signerCaps = state
        .transactions[event.transactionIndex]
        .signerCapabilitiesInfo
        .signerCapabilities[event.capabilityIndex]
        .copyWith(
      clist: newCaps,
    );

    final List<SignerCapabilities> newSignerCaps = List.from(
      state.transactions[event.transactionIndex].signerCapabilitiesInfo
          .signerCapabilities,
    );
    newSignerCaps[event.capabilityIndex] = signerCaps;

    final SignerCapabilitiesInfo info = state
        .transactions[event.transactionIndex].signerCapabilitiesInfo
        .copyWith(
      signerCapabilities: newSignerCaps,
    );

    final TransactionModel model = state.transactions[event.transactionIndex]
        .copyWith(signerCapabilitiesInfo: info);

    emit(
      state.copyWith(
        transactions: updateTransactionAtIndex(
          event.transactionIndex,
          model,
        ),
      ),
    );
  }

  List<TransactionModel> updateTransactionAtIndex(
    int index,
    TransactionModel model,
  ) {
    final List<TransactionModel> newMetadata = List.from(state.transactions);
    newMetadata[index] = state.transactions[index].copyWithOther(
      other: model,
    );
    return newMetadata;
  }

  // @override
  // TransactionsState? fromJson(Map<String, dynamic> json) {
  //   return json.isNotEmpty
  //       ? TransactionsState(
  //           selectedIndex: json['selectedIndex'],
  //           transactions: json['transactions'].map(
  //             (e) => TransactionModel.fromJson(e),
  //           ),
  //         )
  //       : null;
  // }

  // @override
  // Map<String, dynamic>? toJson(TransactionsState state) {
  //   return {
  //     'selectedIndex': state.selectedIndex,
  //     'transactions': state.transactions.map((e) => e.toJson()),
  //   };
  // }
}
