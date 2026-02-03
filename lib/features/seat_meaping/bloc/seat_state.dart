import 'package:equatable/equatable.dart';

enum SeatGender { male, female }

class SeatState extends Equatable {
  final Map<String, SeatGender> selectedSeats;

  const SeatState({this.selectedSeats = const {}});

  SeatState copyWith({Map<String, SeatGender>? selectedSeats}) {
    return SeatState(selectedSeats: selectedSeats ?? this.selectedSeats);
  }

  @override
  List<Object?> get props => [selectedSeats];
}
