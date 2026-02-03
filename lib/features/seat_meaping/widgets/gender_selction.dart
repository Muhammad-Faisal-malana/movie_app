
  import 'package:demo_app/features/seat_meaping/bloc/seat_bloc.dart';
import 'package:demo_app/features/seat_meaping/bloc/seat_event.dart';
import 'package:demo_app/features/seat_meaping/bloc/seat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showGenderSelectionDialog(BuildContext context, String seatId) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Gender',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _GenderOption(
                    icon: Icons.male,
                    label: 'Male',
                    color: Colors.blueAccent,
                    onTap: () {
                      context.read<SeatBloc>().add(
                        SelectSeat(seatId, SeatGender.male),
                      );
                      Navigator.pop(ctx);
                    },
                  ),
                  _GenderOption(
                    icon: Icons.female,
                    label: 'Female',
                    color: Colors.pinkAccent,
                    onTap: () {
                      context.read<SeatBloc>().add(
                        SelectSeat(seatId, SeatGender.female),
                      );
                      Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


class _GenderOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _GenderOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
