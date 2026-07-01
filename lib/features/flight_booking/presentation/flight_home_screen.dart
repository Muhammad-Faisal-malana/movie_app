import 'dart:math' as math;
import 'package:demo_app/core/utils/app_colors.dart';
import 'package:demo_app/features/flight_booking/models/flight_model.dart';
import 'package:demo_app/features/flight_booking/presentation/flight_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class FlightHomeScreen extends StatefulWidget {
  const FlightHomeScreen({super.key});

  @override
  State<FlightHomeScreen> createState() => _FlightHomeScreenState();
}

class _FlightHomeScreenState extends State<FlightHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _planeController;
  late AnimationController _cloudController;
  late AnimationController _pulseController;

  String _tripType = 'One Way';
  String _flightClass = 'Economy';
  String _fromCity = 'New York';
  String _fromCode = 'JFK';
  String _toCity = 'London';
  String _toCode = 'LHR';
  String _date = 'Feb 21, 2026';
  int _passengers = 1;

  final List<String> _tripTypes = ['One Way', 'Round Trip', 'Multi-City'];
  final List<String> _classes = ['Economy', 'Business', 'First Class'];

  @override
  void initState() {
    super.initState();
    _planeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _planeController.dispose();
    _cloudController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _swapCities() {
    setState(() {
      final tmpCity = _fromCity;
      final tmpCode = _fromCode;
      _fromCity = _toCity;
      _fromCode = _toCode;
      _toCity = tmpCity;
      _toCode = tmpCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.airSurface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── Hero Header ───
            _buildHeroHeader(screenH),

            const SizedBox(height: 24),

            // ─── Search Card ───
            _buildSearchCard(context),

            const SizedBox(height: 32),

            // ─── Popular Routes ───
            _buildPopularRoutes(),

            const SizedBox(height: 32),

            // ─── Promos ───
            _buildPromoSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ─── HERO HEADER ───────────────────────────────────────────────────────────
  Widget _buildHeroHeader(double screenH) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background gradient sky
        Container(
          height: screenH * 0.42,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF0A0E2A), Color(0xFF1A1F5E), Color(0xFF2D3480)],
            ),
          ),
        ),

        // Stars
        ...List.generate(30, (i) {
          final rng = math.Random(i * 47);
          return Positioned(
            left: rng.nextDouble() * 400,
            top: rng.nextDouble() * (screenH * 0.25),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) {
                final opacity =
                    0.3 + 0.7 * _pulseController.value * (rng.nextDouble());
                return Container(
                  width: rng.nextDouble() * 3 + 1,
                  height: rng.nextDouble() * 3 + 1,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(opacity),
                    shape: BoxShape.circle,
                  ),
                );
              },
            ),
          );
        }),

        // Animated Clouds
        AnimatedBuilder(
          animation: _cloudController,
          builder: (_, __) {
            final offset = _cloudController.value * 400 - 200;
            return Positioned(
              left: offset,
              top: screenH * 0.12,
              child: Opacity(
                opacity: 0.12,
                child: Image.network(
                  'https://i.imgur.com/placeholder.png',
                  width: 200,
                  errorBuilder: (_, __, ___) => Row(
                    children: [
                      _cloudShape(120, 50),
                      const SizedBox(width: 20),
                      _cloudShape(80, 35),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Subtle clouds rendered as shapes
        Positioned(
          right: -20,
          top: screenH * 0.06,
          child: AnimatedBuilder(
            animation: _cloudController,
            builder: (_, __) {
              final offset =
                  math.sin(_cloudController.value * math.pi * 2) * 15;
              return Transform.translate(
                offset: Offset(offset, 0),
                child: Opacity(opacity: 0.1, child: _cloudShape(160, 60)),
              );
            },
          ),
        ),

        // Main plane animation
        AnimatedBuilder(
          animation: _planeController,
          builder: (_, __) {
            final t = _planeController.value;
            // Parabolic path
            final x = -60.0 + t * (MediaQuery.of(context).size.width + 120);
            final baseY = screenH * 0.28;
            final y = baseY - math.sin(t * math.pi) * 60;

            return Positioned(
              left: x,
              top: y,
              child: Transform.rotate(
                angle: -0.12 + math.sin(t * math.pi) * 0.08,
                child: const Text('✈', style: TextStyle(fontSize: 40)),
              ),
            );
          },
        ),

        // Title content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good Morning ✨',
                          style: GoogleFonts.outfit(
                            color: AppColors.airAccent.withOpacity(0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ).animate().fadeIn(delay: 200.ms),
                        Text(
                          'Where to fly?',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.2),
                      ],
                    ),
                    // Avatar
                    Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.airAccent,
                                AppColors.airBlueMid,
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'JD',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(delay: 400.ms)
                        .scale(begin: const Offset(0.8, 0.8)),
                  ],
                ),

                const SizedBox(height: 24),

                // Trip type selector
                _buildTripTypeSelector(),

                SizedBox(height: screenH * 0.12),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _cloudShape(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(h / 2),
      ),
    );
  }

  Widget _buildTripTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _tripTypes.map((type) {
          final isSelected = type == _tripType;
          return GestureDetector(
            onTap: () => setState(() => _tripType = type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.accentGradient : null,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                type,
                style: GoogleFonts.outfit(
                  color: isSelected ? Colors.white : Colors.white60,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  // ─── SEARCH CARD ──────────────────────────────────────────────────────────
  Widget _buildSearchCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child:
          Container(
                decoration: BoxDecoration(
                  gradient: AppColors.cardGradient,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.airBlueMid.withOpacity(0.4),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // From → To
                      _buildRouteRow(),

                      const SizedBox(height: 20),

                      // Divider
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Date & Passengers
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoTile(
                              Icons.calendar_today_rounded,
                              'Date',
                              _date,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(child: _buildPassengerTile()),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Class selector
                      _buildClassSelector(),

                      const SizedBox(height: 24),

                      // Search Button
                      _buildSearchButton(context),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, curve: Curves.easeOut),
    );
  }

  Widget _buildRouteRow() {
    return Row(
      children: [
        Expanded(
          child: _buildCityField(
            label: 'From',
            city: _fromCity,
            code: _fromCode,
            icon: Icons.flight_takeoff_rounded,
          ),
        ),

        // Swap button
        GestureDetector(
          onTap: _swapCities,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (_, __) {
              return Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.accentGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.airAccent.withOpacity(
                        0.3 + 0.3 * _pulseController.value,
                      ),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.swap_horiz_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              );
            },
          ),
        ),

        Expanded(
          child: _buildCityField(
            label: 'To',
            city: _toCity,
            code: _toCode,
            icon: Icons.flight_land_rounded,
            isRight: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCityField({
    required String label,
    required String city,
    required String code,
    required IconData icon,
    bool isRight = false,
  }) {
    return Column(
      crossAxisAlignment: isRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isRight
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!isRight) ...[
              Icon(icon, color: AppColors.airAccent, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.outfit(
                color: Colors.white38,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),
            if (isRight) ...[
              const SizedBox(width: 6),
              Icon(icon, color: AppColors.airAccent, size: 16),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          code,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
          ),
          textAlign: isRight ? TextAlign.right : TextAlign.left,
        ),
        Text(
          city,
          style: GoogleFonts.outfit(
            color: Colors.white60,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          textAlign: isRight ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.airAccent, size: 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: Colors.white38,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.people_alt_rounded,
                      color: AppColors.airAccent,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Passengers',
                      style: GoogleFonts.outfit(
                        color: Colors.white38,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '$_passengers Adult${_passengers > 1 ? 's' : ''}',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  if (_passengers < 9) _passengers++;
                }),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.airAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.airAccent,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: () => setState(() {
                  if (_passengers > 1) _passengers--;
                }),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white54,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClassSelector() {
    return Row(
      children: _classes.map((cls) {
        final isSelected = cls == _flightClass;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _flightClass = cls),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected ? AppColors.accentGradient : null,
                color: isSelected ? null : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : Colors.white.withOpacity(0.08),
                ),
              ),
              child: Text(
                cls,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: isSelected ? Colors.white : Colors.white38,
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, a, b) => FlightResultsScreen(
              from: _fromCity,
              fromCode: _fromCode,
              to: _toCity,
              toCode: _toCode,
              date: _date,
              passengers: _passengers,
              flightClass: _flightClass,
              flights: FlightModel.getSampleFlights(),
            ),
            transitionsBuilder: (_, anim, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                child: child,
              );
            },
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (_, __) {
          return Container(
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4FC3F7), Color(0xFF2979FF)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.airAccent.withOpacity(
                    0.3 + 0.2 * _pulseController.value,
                  ),
                  blurRadius: 20 + 10 * _pulseController.value,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                Text(
                  'Search Flights',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── POPULAR ROUTES ───────────────────────────────────────────────────────
  Widget _buildPopularRoutes() {
    final routes = [
      {
        'from': 'DXB',
        'to': 'SIN',
        'label': 'Dubai → Singapore',
        'price': '\$420',
        'duration': '7h',
        'color1': const Color(0xFF4FC3F7),
        'color2': const Color(0xFF0288D1),
      },
      {
        'from': 'LHR',
        'to': 'CDG',
        'label': 'London → Paris',
        'price': '\$180',
        'duration': '1h 20m',
        'color1': const Color(0xFFCE93D8),
        'color2': const Color(0xFF7B1FA2),
      },
      {
        'from': 'JFK',
        'to': 'LAX',
        'label': 'New York → LA',
        'price': '\$210',
        'duration': '5h 30m',
        'color1': const Color(0xFF80DEEA),
        'color2': const Color(0xFF00838F),
      },
      {
        'from': 'SYD',
        'to': 'NRT',
        'label': 'Sydney → Tokyo',
        'price': '\$680',
        'duration': '9h 50m',
        'color1': const Color(0xFFFFCC80),
        'color2': const Color(0xFFE65100),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Routes',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'See all',
                style: GoogleFonts.outfit(
                  color: AppColors.airAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: routes.length,
            itemBuilder: (_, i) {
              final r = routes[i];
              return _buildRouteCard(r, i)
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 700 + i * 100))
                  .slideX(begin: 0.3, end: 0);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> r, int i) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (r['color1'] as Color).withOpacity(0.25),
            (r['color2'] as Color).withOpacity(0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (r['color1'] as Color).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                r['from'] as String,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white24,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    ),
                    const Text('✈', style: TextStyle(fontSize: 12)),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.white24,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                r['to'] as String,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            r['label'] as String,
            style: GoogleFonts.outfit(color: Colors.white60, fontSize: 11),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                r['price'] as String,
                style: GoogleFonts.outfit(
                  color: r['color1'] as Color,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  r['duration'] as String,
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── PROMOS ───────────────────────────────────────────────────────────────
  Widget _buildPromoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Special Deals',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ).animate().fadeIn(delay: 800.ms),
          const SizedBox(height: 16),
          _buildPromoCard(
            title: 'Business Class Sale',
            subtitle: 'Up to 40% off on premium seats',
            badge: 'LIMITED',
            color1: const Color(0xFF7B1FA2),
            color2: const Color(0xFF4A0072),
          ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.3, end: 0),
          const SizedBox(height: 12),
          _buildPromoCard(
            title: 'Early Bird Offer',
            subtitle: 'Book 60 days in advance & save \$200',
            badge: 'EARLY BIRD',
            color1: const Color(0xFF00838F),
            color2: const Color(0xFF004D40),
          ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }

  Widget _buildPromoCard({
    required String title,
    required String subtitle,
    required String badge,
    required Color color1,
    required Color color2,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [color1.withOpacity(0.4), color2.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color1.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color1,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
