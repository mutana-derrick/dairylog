import 'package:equatable/equatable.dart';
import '../data/models/farmer_model.dart';

class FarmersState extends Equatable {
  final List<Farmer> farmers;
  final bool isLoading;
  final String? error;

  const FarmersState({
    required this.farmers,
    required this.isLoading,
    this.error,
  });

  factory FarmersState.initial() {
    return const FarmersState(
      farmers: [],
      isLoading: false,
      error: null,
    );
  }

  FarmersState copyWith({
    List<Farmer>? farmers,
    bool? isLoading,
    String? error,
  }) {
    return FarmersState(
      farmers: farmers ?? this.farmers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [farmers, isLoading, error];
}
