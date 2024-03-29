import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../ticker/ticker.dart';

part 'ticker_event.dart';
part 'ticker_state.dart';

class TickerBloc extends Bloc<TickerEvent, TickerState> {
  final Ticker ticker;
  late StreamSubscription<int> subscription;

  TickerBloc(this.ticker) : super(Initial());

  @override
  Stream<TickerState> mapEventToState(TickerEvent event) async* {
    if (event is StartTicker) {
      subscription.cancel();
      subscription = ticker.tick().listen((tick) => add(Tick(tick)));
    }
    if (event is Tick) {
      yield Update(event.tickCount);
    }
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
