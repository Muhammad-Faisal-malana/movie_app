import 'dart:math' as math;
import 'package:demo_app/core/utils/app_colors.dart';
import 'package:demo_app/features/flight_booking/models/flight_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class FlightConfirmationScreen extends StatefulWidget {
  final FlightModel flight;
  final List<String> selectedSeats;
  final double totalPrice;

  const FlightConfirmationScreen({
    super.key,
    required this.flight,
    required this.selectedSeats,
    required this.totalPrice,
  });

  @override
  State<FlightConfirmationScreen> createState() =>
      _FlightConfirmationScreenState();
}

class _FlightConfirmationScreenState extends State<FlightConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _successRingController;
  late AnimationController _floatController;
  late AnimationController _planeController;
  bool _ticketRevealed = false;

  @override
  void initState() {
    super.initState();

    _successRingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _planeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Reveal ticket after a delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _ticketRevealed = true);
    });
  }

  @override
  void dispose() {
    _successRingController.dispose();
    _floatController.dispose();
    _planeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.airSurface,
      body: Stack(
        children: [
          // Background particles
          _buildParticles(),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Success animation
                  _buildSuccessSection(),

                  const SizedBox(height: 32),

                  // BOARDING PASS
                  if (_ticketRevealed) _buildBoardingPass(),

                  const SizedBox(height: 32),

                  // Action buttons
                  if (_ticketRevealed) _buildActionButtons(context),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── BACKGROUND PARTICLES ─────────────────────────────────────────────────
  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (_, __) {
        return Stack(
          children: List.generate(20, (i) {
            final rng = math.Random(i * 13);
            final x = rng.nextDouble() * 400;
            final y = rng.nextDouble() * 800;
            final size = rng.nextDouble() * 4 + 1;
            final speed = rng.nextDouble() * 0.5 + 0.5;
            final dy =
                math.sin(
                  (_floatController.value * speed + i * 0.3) * math.pi * 2,
                ) *
                20;

            return Positioned(
              left: x,
              top: y + dy,
              child: Opacity(
                opacity: 0.15 + rng.nextDouble() * 0.2,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: i % 3 == 0
                        ? AppColors.airAccent
                        : i % 3 == 1
                        ? AppColors.airGold
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ─── SUCCESS SECTION ──────────────────────────────────────────────────────
  Widget _buildSuccessSection() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _successRingController,
          builder: (_, __) {
            final v = _successRingController.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer ring
                Container(
                  width: 120 * v,
                  height: 120 * v,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.airSuccess.withOpacity(0.2 * v),
                      width: 2,
                    ),
                  ),
                ),
                // Mid ring
                Container(
                  width: 90 * v,
                  height: 90 * v,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.airSuccess.withOpacity(0.3 * v),
                      width: 2,
                    ),
                  ),
                ),
                // Inner circle
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.airSuccess.withOpacity(0.3),
                        AppColors.airSuccess.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.airSuccess.withOpacity(0.6),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.airSuccess,
                    size: 36 * v,
                  ),
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        Text(
          'Booking Confirmed! 🎉',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3, end: 0),

        const SizedBox(height: 8),

        Text(
          'Your boarding passes are ready. Have a great flight!',
          style: GoogleFonts.outfit(color: Colors.white54, fontSize: 14),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 700.ms),

        const SizedBox(height: 20),

        // Animated plane trail
        AnimatedBuilder(
          animation: _planeController,
          builder: (_, __) {
            return SizedBox(
              width: 280,
              height: 40,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  // Route line
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.airAccent.withOpacity(0.0),
                              AppColors.airAccent.withOpacity(0.3),
                              AppColors.airAccent.withOpacity(0.5),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Animated plane
                  Positioned(
                    left: _planeController.value * 240,
                    child: const Text('✈', style: TextStyle(fontSize: 22)),
                  ),
                  // City labels
                  Positioned(
                    left: 0,
                    child: Text(
                      widget.flight.fromCode,
                      style: GoogleFonts.outfit(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Text(
                      widget.flight.toCode,
                      style: GoogleFonts.outfit(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ).animate().fadeIn(delay: 900.ms),
      ],
    );
  }

  // ─── BOARDING PASS ────────────────────────────────────────────────────────
  Widget _buildBoardingPass() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child:
          AnimatedBuilder(
                animation: _floatController,
                builder: (_, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatController.value * 6 - 3),
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.airBlueMid.withOpacity(0.5),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                      BoxShadow(
                        color: AppColors.airAccent.withOpacity(0.1),
                        blurRadius: 60,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Column(
                      children: [
                        // ─ TOP PART ─
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1A1F5E), Color(0xFF2D3480)],
                            ),
                          ),
                          child: Column(
                            children: [
                              // Airline & flight
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.flight.airline,
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        'Flight ${widget.flight.id}',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white54,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // BOARDING PASS label
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.airAccent.withOpacity(
                                        0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.airAccent.withOpacity(
                                          0.4,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'BOARDING PASS',
                                      style: GoogleFonts.outfit(
                                        color: AppColors.airAccent,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 28),

                              // Route
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.flight.fromCode,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 42,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        Text(
                                          widget.flight.from,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white60,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Center plane icon
                                  Column(
                                    children: [
                                      const Text(
                                        '✈',
                                        style: TextStyle(fontSize: 28),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        widget.flight.duration,
                                        style: GoogleFonts.outfit(
                                          color: Colors.white54,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          widget.flight.toCode,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 42,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -1,
                                          ),
                                        ),
                                        Text(
                                          widget.flight.to,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white60,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),

                              // Details row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _PassDetail(
                                    label: 'DATE',
                                    value: widget.flight.date,
                                  ),
                                  _PassDetail(
                                    label: 'DEPARTS',
                                    value: widget.flight.departureTime,
                                  ),
                                  _PassDetail(
                                    label: 'ARRIVES',
                                    value: widget.flight.arrivalTime,
                                  ),
                                  _PassDetail(
                                    label: 'CLASS',
                                    value: widget.flight.flightClass,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ─ TEAR LINE ─
                        _buildTearLine(),

                        // ─ BOTTOM PART ─
                        Container(
                          padding: const EdgeInsets.all(24),
                          color: const Color(0xFF101432),
                          child: Column(
                            children: [
                              // Passenger & seats
                              Row(
                                children: [
                                  Expanded(
                                    child: _PassDetail(
                                      label: 'PASSENGER',
                                      value: 'John Doe',
                                      big: true,
                                    ),
                                  ),
                                  Expanded(
                                    child: _PassDetail(
                                      label:
                                          'SEAT${widget.selectedSeats.length > 1 ? 'S' : ''}',
                                      value: widget.selectedSeats.join(', '),
                                      big: true,
                                      accent: true,
                                    ),
                                  ),
                                  Expanded(
                                    child: _PassDetail(
                                      label: 'GATE',
                                      value: 'B24',
                                      big: true,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Price + class row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _PassDetail(
                                    label: 'TOTAL FARE',
                                    value:
                                        '\$${widget.totalPrice.toStringAsFixed(0)}',
                                    valueColor: AppColors.airGold,
                                  ),
                                  _PassDetail(
                                    label: 'BOOKING REF',
                                    value: 'SKY${widget.flight.id}',
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Barcode
                              _buildBarcode(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: 0.4, end: 0, curve: Curves.easeOutBack),
    );
  }

  Widget _buildTearLine() {
    return Container(
      color: const Color(0xFF101432),
      child: Row(
        children: [
          // Left cutout
          Transform.translate(
            offset: const Offset(-14, 0),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.airSurface,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Dashed line
          Expanded(
            child: LayoutBuilder(
              builder: (_, constraints) {
                final dashCount = (constraints.maxWidth / 12).floor();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(dashCount, (i) {
                    return Container(
                      width: 6,
                      height: 1.5,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          // Right cutout
          Transform.translate(
            offset: const Offset(14, 0),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.airSurface,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcode() {
    return Column(
      children: [
        // Fake barcode bars
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(40, (i) {
            final rng = math.Random(i * 7 + 3);
            final width = rng.nextDouble() * 3 + 1.5;
            final height = 40.0 + rng.nextDouble() * 20;
            return Container(
              width: width,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(1),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'SKY-${widget.flight.id}-${widget.selectedSeats.first.replaceAll(RegExp(r'[^0-9]'), '')}',
          style: GoogleFonts.robotoMono(
            color: Colors.white38,
            fontSize: 10,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  // ─── ACTION BUTTONS ───────────────────────────────────────────────────────
  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Download button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4FC3F7), Color(0xFF2979FF)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.airAccent.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.download_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Download Boarding Pass',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3, end: 0),

          const SizedBox(height: 12),

          // Home button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.home_rounded,
                      color: Colors.white70,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Back to Home',
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }
}

// ─── BOARDING PASS DETAIL ────────────────────────────────────────────────────

class _PassDetail extends StatelessWidget {
  final String label;
  final String value;
  final bool big;
  final bool accent;
  final Color? valueColor;

  const _PassDetail({
    required this.label,
    required this.value,
    this.big = false,
    this.accent = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white38,
            fontSize: 9,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: valueColor ?? (accent ? AppColors.airAccent : Colors.white),
            fontSize: big ? 18 : 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
