part of 'bills_bloc.dart';

abstract class BillsEvent extends Equatable {
  const BillsEvent();
  @override
  List<Object?> get props => [];
}

class BillsLoadRequested extends BillsEvent {
  final String? urlOverride;
  const BillsLoadRequested({this.urlOverride});
}

class BillsFlipTick extends BillsEvent {
  const BillsFlipTick();
}

class BillsDispose extends BillsEvent {
  const BillsDispose();
}
