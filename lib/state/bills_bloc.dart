import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/bill_section.dart';
import '../data/repository/global_repository.dart';

part 'bills_event.dart';
part 'bills_state.dart';

class BillsBloc extends Bloc<BillsEvent, BillsState> {
  final GlobalRepository repo;
  Timer? _flipTimer;

  BillsBloc(this.repo) : super(BillsState.initial()) {
    on<BillsLoadRequested>(_onLoadRequested);
    on<BillsFlipTick>(_onFlipTick);
    on<BillsDispose>(_onDispose);
  }

  Future<void> _onLoadRequested(
    BillsLoadRequested event,
    Emitter<BillsState> emit,
  ) async {
    emit(state.copyWith(status: BillsStatus.loading));
    try {
      final section = await repo.fetchBillsSection(
        urlOverride: event.urlOverride,
      );

      // Setup a single periodic flip timer if any card has flipper_config
      final firstWithFlip = section.cards
          .where((c) => c.flipper != null)
          .cast<dynamic>()
          .toList();
      final int delayMs = firstWithFlip.isNotEmpty
          ? (firstWithFlip.first.flipper?.flipDelayMs ?? 0)
          : 0;

      _flipTimer?.cancel();
      if (delayMs > 0) {
        _flipTimer = Timer.periodic(Duration(milliseconds: delayMs), (_) {
          add(const BillsFlipTick());
        });
      }

      emit(
        state.copyWith(
          status: BillsStatus.success,
          section: section,
          currentFlipIndex: 0,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BillsStatus.failure, error: e.toString()));
    }
  }

  void _onFlipTick(BillsFlipTick event, Emitter<BillsState> emit) {
    if (state.section == null) return;
    emit(state.copyWith(currentFlipIndex: state.currentFlipIndex + 1));
  }

  Future<void> _onDispose(BillsDispose event, Emitter<BillsState> emit) async {
    _flipTimer?.cancel();
  }

  @override
  Future<void> close() {
    _flipTimer?.cancel();
    return super.close();
  }
}
