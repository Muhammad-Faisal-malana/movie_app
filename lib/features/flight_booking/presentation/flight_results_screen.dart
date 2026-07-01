import 'package:demo_app/core/utils/app_colors.dart';
import 'package:demo_app/features/flight_booking/models/flight_model.dart';
import 'package:demo_app/features/flight_booking/presentation/flight_seat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class FlightResultsScreen extends StatefulWidget {
  final String from;
  final String fromCode;
  final String to;
  final String toCode;
  final String date;
  final int passengers;
  final String flightClass;
  final List<FlightModel> flights;

  const FlightResultsScreen({
    super.key,
    required this.from,
    required this.fromCode,
    required this.to,
    required this.toCode,
    required this.date,
    required this.passengers,
    required this.flightClass,
    required this.flights,
  });

  @override
  State<FlightResultsScreen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<FlightResultsScreen>
    with TickerProviderStateMixin {
  String _sortBy = 'Price';
  late AnimationController _planeTrailController;

  @override
  void initState() {
    super.initState();
    _planeTrailController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
  }

  @override
  void dispose() {
    _planeTrailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.airSurface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverHeader(context),
          _buildSortBar(),
          _buildFlightList(),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildSliverHeader(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E2A), Color(0xFF1A1F5E), Color(0xFF23297A)],
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        child: Column(
          children: [
            // Back + title row
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Available Flights',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      widget.date,
                      style: GoogleFonts.outfit(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.airAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.airAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    '${widget.flights.length} Flights',
                    style: GoogleFonts.outfit(
                      color: AppColors.airAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 28),

            // Route display
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.fromCode,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          widget.from,
                          style: GoogleFonts.outfit(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Animated plane trail
                  Expanded(
                    child: AnimatedBuilder(
                      animation: _planeTrailController,
                      builder: (_, __) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Dashed trail
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(8, (i) {
                                return AnimatedOpacity(
                                  duration: Duration(
                                    milliseconds: 200 + i * 100,
                                  ),
                                  opacity:
                                      _planeTrailController.value > i * 0.12
                                      ? 1.0
                                      : 0.0,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 2,
                                        decoration: BoxDecoration(
                                          color: AppColors.airAccent
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                            1,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                  ),
                                );
                              }),
                            ),
                            // Plane icon
                            Transform.translate(
                              offset: Offset(
                                -50 + 100 * _planeTrailController.value,
                                0,
                              ),
                              child: const Text(
                                '✈',
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.toCode,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          widget.to,
                          style: GoogleFonts.outfit(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 16),

            // Passenger & class info
            Row(
              children: [
                _buildChip(
                  Icons.person_rounded,
                  '${widget.passengers} Pax',
                  AppColors.airAccent,
                ),
                const SizedBox(width: 10),
                _buildChip(
                  Icons.airline_seat_recline_normal_rounded,
                  widget.flightClass,
                  AppColors.airGold,
                ),
              ],
            ).animate().fadeIn(delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildSortBar() {
    final sorts = ['Price', 'Duration', 'Rating', 'Departure'];
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
        child: Row(
          children: [
            Text(
              'Sort by:',
              style: GoogleFonts.outfit(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: sorts.map((s) {
                    final isSelected = s == _sortBy;
                    return GestureDetector(
                      onTap: () => setState(() => _sortBy = s),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? AppColors.accentGradient
                              : null,
                          color: isSelected
                              ? null
                              : Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : Colors.white.withOpacity(0.1),
                          ),
                        ),
                        child: Text(
                          s,
                          style: GoogleFonts.outfit(
                            color: isSelected ? Colors.white : Colors.white54,
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 400.ms),
    );
  }

  SliverList _buildFlightList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate((_, i) {
        if (i >= widget.flights.length) return null;
        final flight = widget.flights[i];
        return _FlightCard(flight: flight, index: i)
            .animate()
            .fadeIn(delay: Duration(milliseconds: 500 + i * 100))
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOut);
      }, childCount: widget.flights.length),
    );
  }
}

// ─── FLIGHT CARD ─────────────────────────────────────────────────────────────

class _FlightCard extends StatefulWidget {
  final FlightModel flight;
  final int index;

  const _FlightCard({required this.flight, required this.index});

  @override
  State<_FlightCard> createState() => _FlightCardState();
}

class _FlightCardState extends State<_FlightCard> {
  bool _isExpanded = false;

  Color get _classColor {
    switch (widget.flight.flightClass) {
      case 'Business':
        return AppColors.airAccent;
      case 'First Class':
        return AppColors.airGold;
      default:
        return AppColors.airSuccess;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _isExpanded
                ? AppColors.airAccent.withOpacity(0.4)
                : Colors.white.withOpacity(0.07),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            if (_isExpanded)
              BoxShadow(
                color: AppColors.airAccent.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Airline header
                  Row(
                    children: [
                      // Airline logo placeholder
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.airBlueMid,
                              AppColors.airAccent.withOpacity(0.6),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            widget.flight.airlineCode,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.flight.airline,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Flight ${widget.flight.id}',
                              style: GoogleFonts.outfit(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Class badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _classColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _classColor.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          widget.flight.flightClass,
                          style: GoogleFonts.outfit(
                            color: _classColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Time row
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.flight.departureTime,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            widget.flight.fromCode,
                            style: GoogleFonts.outfit(
                              color: Colors.white54,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.flight.duration,
                              style: GoogleFonts.outfit(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.airAccent,
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(0.15),
                                  ),
                                ),
                                const Text(
                                  '✈',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: Colors.white.withOpacity(0.15),
                                  ),
                                ),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.airAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Non-stop',
                              style: GoogleFonts.outfit(
                                color: AppColors.airSuccess,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.flight.arrivalTime,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            widget.flight.toCode,
                            style: GoogleFonts.outfit(
                              color: Colors.white54,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Bottom: amenities + price
                  Row(
                    children: [
                      // Amenities
                      Row(
                        children: [
                          _AmenityChip(
                            icon: Icons.wifi_rounded,
                            active: widget.flight.hasWifi,
                          ),
                          const SizedBox(width: 8),
                          _AmenityChip(
                            icon: Icons.restaurant_rounded,
                            active: widget.flight.hasMeals,
                          ),
                          const SizedBox(width: 8),
                          _RatingChip(rating: widget.flight.rating),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${widget.flight.price.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'per person',
                            style: GoogleFonts.outfit(
                              color: Colors.white38,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Expanded section
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: _isExpanded ? null : 0,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(),
              child: _isExpanded
                  ? Column(
                      children: [
                        // Dashed separator
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: List.generate(30, (i) {
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 2,
                                  ),
                                  height: 1,
                                  color: i.isEven
                                      ? Colors.white.withOpacity(0.12)
                                      : Colors.transparent,
                                ),
                              );
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // Seats info
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _DetailRow(
                                    icon: Icons.event_seat_rounded,
                                    label: 'Available Seats',
                                    value:
                                        '${widget.flight.availableSeats} seats',
                                    valueColor:
                                        widget.flight.availableSeats < 10
                                        ? Colors.orange
                                        : AppColors.airSuccess,
                                  ),
                                  _DetailRow(
                                    icon: Icons.star_rounded,
                                    label: 'Rating',
                                    value: '${widget.flight.rating}/5.0',
                                    valueColor: AppColors.airGold,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Book button
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, a, b) =>
                                          FlightSeatScreen(
                                            flight: widget.flight,
                                          ),
                                      transitionsBuilder: (_, anim, __, child) {
                                        return SlideTransition(
                                          position:
                                              Tween<Offset>(
                                                begin: const Offset(1, 0),
                                                end: Offset.zero,
                                              ).animate(
                                                CurvedAnimation(
                                                  parent: anim,
                                                  curve: Curves.easeOutCubic,
                                                ),
                                              ),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4FC3F7),
                                        Color(0xFF2979FF),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.airAccent.withOpacity(
                                          0.4,
                                        ),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons
                                            .airline_seat_recline_extra_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Select Seats  →',
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
                            ],
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final bool active;

  const _AmenityChip({required this.icon, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: active
            ? AppColors.airAccent.withOpacity(0.15)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: active
              ? AppColors.airAccent.withOpacity(0.3)
              : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Icon(
        icon,
        color: active ? AppColors.airAccent : Colors.white.withOpacity(0.2),
        size: 16,
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  final double rating;
  const _RatingChip({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.airGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.airGold.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: AppColors.airGold, size: 12),
          const SizedBox(width: 3),
          Text(
            '$rating',
            style: GoogleFonts.outfit(
              color: AppColors.airGold,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38, size: 16),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10),
            ),
            Text(
              value,
              style: GoogleFonts.outfit(
                color: valueColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
