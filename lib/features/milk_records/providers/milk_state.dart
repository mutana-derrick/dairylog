import 'package:freezed_annotation/freezed_annotation.dart';
import '../data/models/milk_record_model.dart';


part 'milk_state.freezed.dart';

@freezed
class MilkState with _$MilkState {
  const factory MilkState({
    @Default([]) List<MilkRecord> records, // All milk records loaded
    @Default(false) bool isLoading,         // Loading state
    String? error,                          // Error message, if any
  }) = _MilkState;
}
