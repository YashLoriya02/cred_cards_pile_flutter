part of 'bills_bloc.dart';

enum BillsStatus { initial, loading, success, failure }

class BillsState extends Equatable {
  final BillsStatus status;
  final BillSection? section;
  final int currentFlipIndex;
  final String? error;

  const BillsState({
    required this.status,
    required this.section,
    required this.currentFlipIndex,
    required this.error,
  });

  factory BillsState.initial() => const BillsState(
    status: BillsStatus.initial,
    section: null,
    currentFlipIndex: 0,
    error: null,
  );

  BillsState copyWith({
    BillsStatus? status,
    BillSection? section,
    int? currentFlipIndex,
    String? error,
  }) {
    return BillsState(
      status: status ?? this.status,
      section: section ?? this.section,
      currentFlipIndex: currentFlipIndex ?? this.currentFlipIndex,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, section, currentFlipIndex, error];
}
