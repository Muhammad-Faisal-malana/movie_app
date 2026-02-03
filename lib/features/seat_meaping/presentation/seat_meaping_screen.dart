import 'package:demo_app/features/seat_meaping/bloc/seat_bloc.dart';
import 'package:demo_app/features/seat_meaping/bloc/seat_event.dart';
import 'package:demo_app/features/seat_meaping/bloc/seat_state.dart';
import 'package:demo_app/features/seat_meaping/widgets/gender_selction.dart';
import 'package:demo_app/features/ticket/presentation/ticket_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeatMappingScreen extends StatelessWidget {
  const SeatMappingScreen({super.key});

  final int rows = 6;
  final int cols = 8;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SeatBloc(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Select Seats')),
        body: BlocBuilder<SeatBloc, SeatState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 20),
                // Screen Indicator
                Container(
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.05),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.elliptical(400, 100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: -5,
                        offset: const Offset(0, -10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "SCREEN",
                    style: TextStyle(
                      color: Colors.white38,
                      letterSpacing: 4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: rows * cols,
                    itemBuilder: (_, index) {
                      final row = index ~/ cols;
                      final col = index % cols;
                      final seatId =
                          '${String.fromCharCode(65 + row)}${col + 1}';
                      final isSelected = state.selectedSeats.containsKey(
                        seatId,
                      );
                      final gender = state.selectedSeats[seatId];

                      return GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            context.read<SeatBloc>().add(RemoveSeat(seatId));
                          } else {
                            showGenderSelectionDialog(context, seatId);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (gender == SeatGender.male
                                      ? Colors.blueAccent
                                      : Colors.pinkAccent)
                                : Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color:
                                          (gender == SeatGender.male
                                                  ? Colors.blueAccent
                                                  : Colors.pinkAccent)
                                              .withOpacity(0.6),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : [],
                            border: Border.all(
                              color: isSelected
                                  ? (gender == SeatGender.male
                                        ? Colors.blue
                                        : Colors.pink)
                                  : Colors.white10,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: isSelected
                                ? Icon(
                                    gender == SeatGender.male
                                        ? Icons.male
                                        : Icons.female,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : Text(
                                    seatId,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: state.selectedSeats.isEmpty
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => TicketConfirmationScreen(
                                      seatCount: state.selectedSeats.length,
                                      seatNames: state.selectedSeats.keys.join(
                                        ', ',
                                      ),
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          disabledBackgroundColor: Colors.grey[800],
                          disabledForegroundColor: Colors.white38,
                        ),
                        child: Text(
                          state.selectedSeats.isEmpty
                              ? 'Select Seats'
                              : 'Confirm Booking (${state.selectedSeats.length})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
