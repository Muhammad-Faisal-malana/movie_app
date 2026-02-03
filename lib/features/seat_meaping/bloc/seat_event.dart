import 'package:demo_app/features/seat_meaping/bloc/seat_state.dart';
import 'package:equatable/equatable.dart';

abstract class SeatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectSeat extends SeatEvent {
  final String seatId;
  final SeatGender gender;
  SelectSeat(this.seatId, this.gender);

  @override
  List<Object?> get props => [seatId, gender];
}

class RemoveSeat extends SeatEvent {
  final String seatId;
  RemoveSeat(this.seatId);

  @override
  List<Object?> get props => [seatId];
}
