import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TicketConfirmationScreen extends StatelessWidget {
  final int seatCount;
  final String seatNames;

  const TicketConfirmationScreen({
    super.key,
    required this.seatCount,
    required this.seatNames,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),

                    // Success Icon
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 80,
                      ),
                    ).animate().scale(
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    ),

                    const SizedBox(height: 32),

                    const Text(
                          "Booking Confirmed!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 300.ms)
                        .slideY(begin: 0.3, end: 0),

                    const SizedBox(height: 12),

                    const Text(
                      "Your tickets have been successfully booked. Enjoy the movie!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ).animate().fadeIn(delay: 500.ms),

                    const SizedBox(height: 48),

                    // Ticket Card
                    TicketCard(seatCount: seatCount, seatNames: seatNames)
                        .animate()
                        .fadeIn(delay: 700.ms)
                        .moveY(begin: 50, end: 0, curve: Curves.easeOut),

                     const SizedBox(height: 20),

                    // Home Button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Back to Home",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ).animate().fadeIn(delay: 1000.ms),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final int seatCount;
  final String seatNames;

  const TicketCard({
    super.key,
    required this.seatCount,
    required this.seatNames,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              image: DecorationImage(
                image: NetworkImage(
                  'https://image.tmdb.org/t/p/w780/kXfqcdQKsToO0OUXHcrrNCHDBzO.jpg',
                ), // Placeholder or pass actual image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "The Shawshank Redemption", // Placeholder
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoColumn(label: "Date", value: "Feb 14"),
                    _InfoColumn(label: "Time", value: "18:30"),
                    _InfoColumn(label: "Seats", value: "$seatCount"),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Text(
                        "Seats Numbers",
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        seatNames,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;

  const _InfoColumn({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
