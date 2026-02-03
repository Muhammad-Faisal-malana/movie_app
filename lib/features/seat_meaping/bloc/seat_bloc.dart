import 'package:flutter_bloc/flutter_bloc.dart';
import 'seat_event.dart';
import 'seat_state.dart';

class SeatBloc extends Bloc<SeatEvent, SeatState> {
  SeatBloc() : super(const SeatState()) {
    on<SelectSeat>(_onSelectSeat);
    on<RemoveSeat>(_onRemoveSeat);
  }

  void _onSelectSeat(SelectSeat event, Emitter<SeatState> emit) {
    final updatedSeats = Map<String, SeatGender>.from(state.selectedSeats);
    updatedSeats[event.seatId] = event.gender;
    emit(state.copyWith(selectedSeats: updatedSeats));
  }

  void _onRemoveSeat(RemoveSeat event, Emitter<SeatState> emit) {
    final updatedSeats = Map<String, SeatGender>.from(state.selectedSeats);
    updatedSeats.remove(event.seatId);
    emit(state.copyWith(selectedSeats: updatedSeats));
  }
}
