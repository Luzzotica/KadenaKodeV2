import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:kadena_multisig/services/settings/settings_event.dart';
import 'package:kadena_multisig/services/settings/settings_state.dart';
import 'package:kadena_multisig/services/transactions/transaction_metadata.dart';

class SettingsBloc extends HydratedBloc<SettingsEvent, SettingsState> {
  SettingsBloc()
      : super(
          SettingsState(
            defaultMetadata: TransactionMetadata(),
          ),
        ) {
    on<UpdateSettings>(_updateSettings);
  }

  void _updateSettings(UpdateSettings event, Emitter<SettingsState> emit) {
    final currentMetadata = state.defaultMetadata;
    final updatedMetadata = currentMetadata.copyWithOther(
      other: event.metadata,
    );

    emit(state.copyWith(defaultMetadata: updatedMetadata));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return json.isNotEmpty
        ? SettingsState(
            defaultMetadata: TransactionMetadata.fromJson(
              json['defaultMetadata'],
            ),
          )
        : null;
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return {
      'defaultMetadata': state.defaultMetadata.toJson(),
    };
  }
}
