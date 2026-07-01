import 'dart:math' as math;
import 'package:demo_app/core/utils/app_colors.dart';
import 'package:demo_app/features/flight_booking/models/flight_model.dart';
import 'package:demo_app/features/flight_booking/presentation/flight_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class FlightSeatScreen extends StatefulWidget {
  final FlightModel flight;
  const FlightSeatScreen({super.key, required this.flight});

  @override
  State<FlightSeatScreen> createState() => _FlightSeatScreenState();
}

class _FlightSeatScreenState extends State<FlightSeatScreen>
    with TickerProviderStateMixin {
  // Airplane layout: A B C [aisle] D E F
  static const int _totalRows = 22;
  static const List<String> _cols = ['A', 'B', 'C', 'D', 'E', 'F'];

  late Set<String> _occupiedSeats;
  final Set<String> _selectedSeats = {};

  late AnimationController _shimmerCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _engineCtrl;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(vsync: this, duration: 2500.ms)
      ..repeat();
    _glowCtrl = AnimationController(vsync: this, duration: 2000.ms)
      ..repeat(reverse: true);
    _engineCtrl = AnimationController(vsync: this, duration: 600.ms)..repeat();

    // Randomise occupied seats
    final rng = math.Random(99);
    _occupiedSeats = {};
    for (int r = 1; r <= _totalRows; r++) {
      for (final c in _cols) {
        if (rng.nextDouble() < 0.42) _occupiedSeats.add('$c$r');
      }
    }
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    _glowCtrl.dispose();
    _engineCtrl.dispose();
    super.dispose();
  }

  void _toggleSeat(String id) {
    if (_occupiedSeats.contains(id)) return;
    setState(() {
      _selectedSeats.contains(id)
          ? _selectedSeats.remove(id)
          : _selectedSeats.add(id);
    });
  }

  _SeatStatus _status(String id) {
    if (_occupiedSeats.contains(id)) return _SeatStatus.occupied;
    if (_selectedSeats.contains(id)) return _SeatStatus.selected;
    return _SeatStatus.available;
  }

  // ─── Zone classification ──────────────────────────────────────────────────
  _Zone _zone(int row) {
    if (row <= 2) return _Zone.firstClass;
    if (row <= 7) return _Zone.business;
    return _Zone.economy;
  }

  @override
  Widget build(BuildContext context) {
    final total =
        widget.flight.price *
        (_selectedSeats.isEmpty ? 1 : _selectedSeats.length);
    return Scaffold(
      backgroundColor: AppColors.airSurface,
      body: Stack(
        children: [
          // ─ Animated background nebula ─
          _AnimatedBackground(glowCtrl: _glowCtrl),

          // ─ Main scroll ─
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              _buildLegend(),
              _buildAirplaneBody(),
              const SliverToBoxAdapter(child: SizedBox(height: 150)),
            ],
          ),

          // ─ Bottom booking panel ─
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomPanel(context, total),
          ),
        ],
      ),
    );
  }

  // ─── APP BAR ──────────────────────────────────────────────────────────────
  SliverToBoxAdapter _buildAppBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF070B25), Color(0xFF111845)],
          ),
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.airBlueMid.withValues(alpha: 0.4),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            _GlassButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Your Seat',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${widget.flight.fromCode}  ✈  ${widget.flight.toCode}  •  ${widget.flight.airline}',
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Animated class badge
            AnimatedBuilder(
              animation: _glowCtrl,
              builder: (_, __) {
                final glow = _glowCtrl.value;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: widget.flight.flightClass == 'First Class'
                        ? AppColors.goldGradient
                        : AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color:
                            (widget.flight.flightClass == 'First Class'
                                    ? AppColors.airGold
                                    : AppColors.airAccent)
                                .withValues(alpha: 0.2 + 0.3 * glow),
                        blurRadius: 12 + 8 * glow,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    widget.flight.flightClass,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  // ─── LEGEND ───────────────────────────────────────────────────────────────
  SliverToBoxAdapter _buildLegend() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        child: Column(
          children: [
            // Zone legend row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ZoneBadge(label: 'First Class', color: AppColors.airGold),
                const SizedBox(width: 12),
                _ZoneBadge(label: 'Business', color: AppColors.airAccent),
                const SizedBox(width: 12),
                _ZoneBadge(label: 'Economy', color: const Color(0xFF7C8DB5)),
              ],
            ),
            const SizedBox(height: 12),
            // Seat status legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SeatLegend(
                  color: const Color(0xFF1E2351),
                  border: Colors.white24,
                  label: 'Free',
                ),
                const SizedBox(width: 16),
                _SeatLegend(color: AppColors.airAccent, label: 'Selected'),
                const SizedBox(width: 16),
                _SeatLegend(
                  color: Colors.white.withValues(alpha: 0.08),
                  label: 'Taken',
                ),
              ],
            ),
          ],
        ),
      ).animate().fadeIn(delay: 300.ms),
    );
  }

  // ─── AIRPLANE BODY ────────────────────────────────────────────────────────
  SliverToBoxAdapter _buildAirplaneBody() {
    return SliverToBoxAdapter(
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 8),

              // ── Nose cone ──
              _buildNoseCone(),

              // ── Cabin rows ──
              ..._buildCabinRows(),

              // ── Wings (rendered inline at row 12) ──

              // ── Tail section ──
              _buildTailSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoseCone() {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (_, __) {
        return CustomPaint(
          painter: _NosePainter(glow: _glowCtrl.value),
          size: const Size(240, 80),
        );
      },
    ).animate().fadeIn(delay: 400.ms).slideY(begin: -0.3, end: 0);
  }

  List<Widget> _buildCabinRows() {
    List<Widget> rows = [];

    for (int rowIdx = 0; rowIdx < _totalRows; rowIdx++) {
      final row = rowIdx + 1;
      final zone = _zone(row);

      // Zone header
      if (row == 1 || row == 3 || row == 8) {
        rows.add(_buildZoneHeader(zone));
      }

      // Wings at row 11-13
      if (row == 11) {
        rows.add(_buildWingsWithRow(row, zone));
        rows.add(_buildWingsWithRow(12, zone));
        rows.add(_buildWingsWithRow(13, zone));
        rowIdx += 2; // skip rows 12 and 13
        continue;
      }

      rows.add(_buildSeatRow(row, zone));
    }

    return rows;
  }

  Widget _buildZoneHeader(_Zone zone) {
    Color zoneColor;
    String label;
    switch (zone) {
      case _Zone.firstClass:
        zoneColor = AppColors.airGold;
        label = '⭐  FIRST CLASS';
        break;
      case _Zone.business:
        zoneColor = AppColors.airAccent;
        label = '💼  BUSINESS CLASS';
        break;
      case _Zone.economy:
        zoneColor = const Color(0xFF7C8DB5);
        label = '🪑  ECONOMY CLASS';
    }

    return Container(
      width: 240,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: zoneColor.withValues(alpha: 0.12),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: zoneColor.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          color: zoneColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildSeatRow(int row, _Zone zone) {
    return Container(
      width: 240,
      color: _zoneBgColor(zone).withValues(alpha: 0.04),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          // Row number
          SizedBox(
            width: 20,
            child: Text(
              '$row',
              style: GoogleFonts.outfit(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Seats A B C
          ..._cols.take(3).map((col) {
            final id = '$col$row';
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _SeatButton(
                seatId: id,
                status: _status(id),
                zone: zone,
                shimmerCtrl: _shimmerCtrl,
                onTap: _toggleSeat,
              ),
            );
          }),
          // Aisle
          SizedBox(
            width: 18,
            child: Center(
              child: Container(
                width: 1,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Seats D E F
          ..._cols.skip(3).map((col) {
            final id = '$col$row';
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: _SeatButton(
                seatId: id,
                status: _status(id),
                zone: zone,
                shimmerCtrl: _shimmerCtrl,
                onTap: _toggleSeat,
              ),
            );
          }),
          // Row number right side
          SizedBox(
            width: 20,
            child: Text(
              '$row',
              style: GoogleFonts.outfit(
                color: Colors.white.withValues(alpha: 0.2),
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 450 + row * 25));
  }

  Widget _buildWingsWithRow(int row, _Zone zone) {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // ── WINGS ──
            CustomPaint(
              painter: _WingPainter(
                glow: _glowCtrl.value,
                shimmer: _shimmerCtrl.value,
                rowIndex: row - 11, // 0,1,2
              ),
              size: const Size(320, 44),
            ),
            // ── Seat row on top of wings ──
            _buildSeatRow(row, zone),
          ],
        );
      },
    ).animate().fadeIn(delay: Duration(milliseconds: 450 + row * 25));
  }

  Widget _buildTailSection() {
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (_, __) {
        return CustomPaint(
          painter: _TailPainter(
            glow: _glowCtrl.value,
            shimmer: _shimmerCtrl.value,
          ),
          size: const Size(240, 110),
        );
      },
    ).animate().fadeIn(delay: 900.ms);
  }

  Color _zoneBgColor(_Zone zone) {
    switch (zone) {
      case _Zone.firstClass:
        return AppColors.airGold;
      case _Zone.business:
        return AppColors.airAccent;
      case _Zone.economy:
        return const Color(0xFF7C8DB5);
    }
  }

  // ─── BOTTOM PANEL ─────────────────────────────────────────────────────────
  Widget _buildBottomPanel(BuildContext context, double total) {
    final has = _selectedSeats.isNotEmpty;
    return AnimatedBuilder(
      animation: _glowCtrl,
      builder: (_, __) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(context).padding.bottom + 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.airSurface.withValues(alpha: 0.0),
                AppColors.airSurface.withValues(alpha: 0.97),
                AppColors.airSurface,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Selected seat chips
              if (has) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _selectedSeats.map((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.airAccent.withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🪑', style: TextStyle(fontSize: 10)),
                          const SizedBox(width: 4),
                          Text(
                            s,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ).animate().fadeIn(duration: 250.ms),
                const SizedBox(height: 12),
              ],
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          has
                              ? '${_selectedSeats.length} seat${_selectedSeats.length > 1 ? 's' : ''}'
                              : 'Tap a seat to select',
                          style: GoogleFonts.outfit(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                        if (has)
                          Text(
                            '\$${total.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: has
                        ? () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  FlightConfirmationScreen(
                                    flight: widget.flight,
                                    selectedSeats: _selectedSeats.toList(),
                                    totalPrice: total,
                                  ),
                              transitionsBuilder: (_, anim, __, child) =>
                                  FadeTransition(opacity: anim, child: child),
                            ),
                          )
                        : null,
                    child: AnimatedContainer(
                      duration: 300.ms,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 17,
                      ),
                      decoration: BoxDecoration(
                        gradient: has
                            ? const LinearGradient(
                                colors: [Color(0xFF4FC3F7), Color(0xFF2979FF)],
                              )
                            : null,
                        color: has
                            ? null
                            : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: has
                            ? [
                                BoxShadow(
                                  color: AppColors.airAccent.withValues(
                                    alpha: 0.35 + 0.2 * _glowCtrl.value,
                                  ),
                                  blurRadius: 20 + 10 * _glowCtrl.value,
                                  offset: const Offset(0, 6),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        'Continue  →',
                        style: GoogleFonts.outfit(
                          color: has ? Colors.white : Colors.white30,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── ENUMS ───────────────────────────────────────────────────────────────────

enum _SeatStatus { available, selected, occupied }

enum _Zone { firstClass, business, economy }

// ─── ANIMATED BACKGROUND ─────────────────────────────────────────────────────

class _AnimatedBackground extends StatelessWidget {
  final AnimationController glowCtrl;
  const _AnimatedBackground({required this.glowCtrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: glowCtrl,
      builder: (_, __) {
        final v = glowCtrl.value;
        return Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -0.3),
              radius: 1.2,
              colors: [Color(0xFF1A2060), Color(0xFF0F1135)],
            ),
          ),
          child: CustomPaint(
            painter: _StarfieldPainter(t: v),
            child: const SizedBox.expand(),
          ),
        );
      },
    );
  }
}

class _StarfieldPainter extends CustomPainter {
  final double t;
  _StarfieldPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = math.Random(77);
    final paint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 60; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 1.5 + 0.5;
      final flicker = math.sin((t + i * 0.17) * math.pi * 2) * 0.5 + 0.5;
      paint.color = Colors.white.withValues(alpha: 0.05 + 0.1 * flicker);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(_StarfieldPainter o) => o.t != t;
}

// ─── CUSTOM PAINTERS ─────────────────────────────────────────────────────────

/// Draws the rounded nose cone (top of plane, view from above)
class _NosePainter extends CustomPainter {
  final double glow;
  _NosePainter({required this.glow});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Body outline
    final bodyPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF2D3480), const Color(0xFF1A1F5E)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // Glowing edge
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6)
      ..color = AppColors.airAccent.withValues(alpha: 0.4 + 0.3 * glow);

    // Nose path (elliptical tip)
    final nosePath = Path();
    nosePath.moveTo(w * 0.22, h);
    nosePath.lineTo(w * 0.22, h * 0.5);
    nosePath.quadraticBezierTo(w * 0.22, 0, w * 0.5, 0);
    nosePath.quadraticBezierTo(w * 0.78, 0, w * 0.78, h * 0.5);
    nosePath.lineTo(w * 0.78, h);
    nosePath.close();

    canvas.drawPath(nosePath, bodyPaint);
    canvas.drawPath(nosePath, glowPaint);

    // Cockpit windows
    final windowPaint = Paint()
      ..color = AppColors.airAccent.withValues(alpha: 0.3 + 0.2 * glow)
      ..style = PaintingStyle.fill;
    // Left window
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.38, h * 0.72),
          width: 12,
          height: 8,
        ),
        const Radius.circular(4),
      ),
      windowPaint,
    );
    // Right window
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.62, h * 0.72),
          width: 12,
          height: 8,
        ),
        const Radius.circular(4),
      ),
      windowPaint,
    );

    // Centre stripe
    final stripePaint = Paint()
      ..color = AppColors.airAccent.withValues(alpha: 0.15)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w * 0.5, h * 0.15), Offset(w * 0.5, h), stripePaint);
  }

  @override
  bool shouldRepaint(_NosePainter o) => o.glow != glow;
}

/// Wings + engines at mid-body rows
class _WingPainter extends CustomPainter {
  final double glow;
  final double shimmer;
  final int rowIndex; // 0=top of wing, 1=middle, 2=bottom

  _WingPainter({
    required this.glow,
    required this.shimmer,
    required this.rowIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Body background (continuation)
    final bodyPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF1A1F5E);

    // Left wing
    final leftWingPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFF0D1240).withValues(alpha: 0.9),
          const Color(0xFF1A1F5E),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w * 0.3, h));

    // Right wing
    final rightWingPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [
          const Color(0xFF0D1240).withValues(alpha: 0.9),
          const Color(0xFF1A1F5E),
        ],
      ).createShader(Rect.fromLTWH(w * 0.7, 0, w * 0.3, h));

    final wingEdgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.airAccent.withValues(alpha: 0.35 + 0.25 * glow);

    // Shimmer sweep on wing
    final shimmerPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.06 + 0.04 * glow),
          Colors.transparent,
        ],
        stops: [
          (shimmer - 0.2).clamp(0.0, 1.0),
          shimmer.clamp(0.0, 1.0),
          (shimmer + 0.2).clamp(0.0, 1.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    // ── Draw based on rowIndex (0 = top edge, 1 = middle, 2 = bottom tapers in) ──
    late Path leftWingPath;
    late Path rightWingPath;

    final bodyLeft = w * 0.285;
    final bodyRight = w * 0.715;

    switch (rowIndex) {
      case 0: // wing root starts – sweep outward
        leftWingPath = Path()
          ..moveTo(bodyLeft, 0)
          ..lineTo(bodyLeft, h)
          ..lineTo(w * 0.05, h)
          ..lineTo(w * 0.06, 0)
          ..close();
        rightWingPath = Path()
          ..moveTo(bodyRight, 0)
          ..lineTo(bodyRight, h)
          ..lineTo(w * 0.95, h)
          ..lineTo(w * 0.94, 0)
          ..close();
        break;
      case 1: // widest span
        leftWingPath = Path()
          ..moveTo(bodyLeft, 0)
          ..lineTo(bodyLeft, h)
          ..lineTo(0, h * 0.75)
          ..lineTo(0, 0)
          ..close();
        rightWingPath = Path()
          ..moveTo(bodyRight, 0)
          ..lineTo(bodyRight, h)
          ..lineTo(w, h * 0.75)
          ..lineTo(w, 0)
          ..close();
        // Engine pods
        _drawEngine(canvas, Offset(w * 0.14, h * 0.5), 10, glow, shimmer);
        _drawEngine(canvas, Offset(w - w * 0.14, h * 0.5), 10, glow, shimmer);
        break;
      case 2: // tapers back in
        leftWingPath = Path()
          ..moveTo(bodyLeft, 0)
          ..lineTo(w * 0.05, 0)
          ..lineTo(w * 0.12, h)
          ..lineTo(bodyLeft, h)
          ..close();
        rightWingPath = Path()
          ..moveTo(bodyRight, 0)
          ..lineTo(w * 0.95, 0)
          ..lineTo(w * 0.88, h)
          ..lineTo(bodyRight, h)
          ..close();
        break;
      default:
        leftWingPath = Path();
        rightWingPath = Path();
    }

    // Body fill for this row
    canvas.drawRect(
      Rect.fromLTWH(bodyLeft, 0, bodyRight - bodyLeft, h),
      bodyPaint,
    );

    // Wings
    canvas.drawPath(leftWingPath, leftWingPaint);
    canvas.drawPath(rightWingPath, rightWingPaint);
    canvas.drawPath(leftWingPath, shimmerPaint);
    canvas.drawPath(rightWingPath, shimmerPaint);
    canvas.drawPath(leftWingPath, wingEdgePaint);
    canvas.drawPath(rightWingPath, wingEdgePaint);

    // Winglet tips on outermost row (row 1 = widest)
    if (rowIndex == 1) {
      _drawWinglet(canvas, Offset(0, h * 0.4), false, glow);
      _drawWinglet(canvas, Offset(w, h * 0.4), true, glow);
    }
  }

  void _drawEngine(
    Canvas canvas,
    Offset center,
    double r,
    double glow,
    double shimmer,
  ) {
    // Engine nacelle
    final nacellePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [const Color(0xFF3A4090), const Color(0xFF0D1240)],
      ).createShader(Rect.fromCircle(center: center, radius: r * 2));

    final glowPaint = Paint()
      ..color = AppColors.airAccent.withValues(alpha: 0.25 + 0.25 * glow)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    // Engine body (oval)
    canvas.drawOval(
      Rect.fromCenter(center: center, width: r * 3.5, height: r * 1.6),
      glowPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: center, width: r * 3, height: r * 1.4),
      nacellePaint,
    );

    // Intake ring
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.airAccent.withValues(alpha: 0.5 + 0.3 * glow);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - r * 0.8, center.dy),
        width: r * 1.0,
        height: r * 1.2,
      ),
      ringPaint,
    );

    // Engine glow exhaust
    final exhaustPaint = Paint()
      ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.15 + 0.15 * glow)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + r, center.dy),
        width: r * 1.5,
        height: r * 0.8,
      ),
      exhaustPaint,
    );
  }

  void _drawWinglet(Canvas canvas, Offset tip, bool isRight, double glow) {
    final paint = Paint()
      ..color = const Color(0xFF2D3480).withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..color = AppColors.airAccent.withValues(alpha: 0.3 + 0.2 * glow)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    if (isRight) {
      path.moveTo(tip.dx - 18, tip.dy + 4);
      path.lineTo(tip.dx - 6, tip.dy - 8);
      path.lineTo(tip.dx - 4, tip.dy + 16);
      path.close();
    } else {
      path.moveTo(tip.dx + 18, tip.dy + 4);
      path.lineTo(tip.dx + 6, tip.dy - 8);
      path.lineTo(tip.dx + 4, tip.dy + 16);
      path.close();
    }
    canvas.drawPath(path, paint);
    canvas.drawPath(path, glowPaint);

    // Navigation light
    final lightPaint = Paint()
      ..color = (isRight ? Colors.green : Colors.red).withValues(
        alpha: 0.7 + 0.3 * glow,
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(
      isRight
          ? Offset(tip.dx - 11, tip.dy + 3)
          : Offset(tip.dx + 11, tip.dy + 3),
      3,
      lightPaint,
    );
  }

  @override
  bool shouldRepaint(_WingPainter o) =>
      o.glow != glow || o.shimmer != shimmer || o.rowIndex != rowIndex;
}

/// Tail: empennage with horizontal stabilisers & vertical fin
class _TailPainter extends CustomPainter {
  final double glow;
  final double shimmer;
  _TailPainter({required this.glow, required this.shimmer});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyLeft = w * 0.285;
    final bodyRight = w * 0.715;

    final bodyPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFF1A1F5E), const Color(0xFF111540)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.airAccent.withValues(alpha: 0.3 + 0.2 * glow);

    // ── Body (fuselage tapers to tail) ──
    final bodyPath = Path();
    bodyPath.moveTo(bodyLeft, 0);
    bodyPath.lineTo(bodyLeft, h * 0.6);
    bodyPath.quadraticBezierTo(bodyLeft, h, w / 2, h);
    bodyPath.quadraticBezierTo(bodyRight, h, bodyRight, h * 0.6);
    bodyPath.lineTo(bodyRight, 0);
    bodyPath.close();
    canvas.drawPath(bodyPath, bodyPaint);
    canvas.drawPath(bodyPath, edgePaint);

    // ── Horizontal stabilisers ──
    final stabPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF141840);
    final stabGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = AppColors.airAccent.withValues(alpha: 0.25 + 0.2 * glow);

    // Left stabiliser
    final leftStab = Path();
    leftStab.moveTo(bodyLeft, h * 0.2);
    leftStab.lineTo(w * 0.04, h * 0.45);
    leftStab.lineTo(w * 0.06, h * 0.55);
    leftStab.lineTo(bodyLeft, h * 0.42);
    leftStab.close();
    canvas.drawPath(leftStab, stabPaint);
    canvas.drawPath(leftStab, stabGlowPaint);

    // Right stabiliser
    final rightStab = Path();
    rightStab.moveTo(bodyRight, h * 0.2);
    rightStab.lineTo(w * 0.96, h * 0.45);
    rightStab.lineTo(w * 0.94, h * 0.55);
    rightStab.lineTo(bodyRight, h * 0.42);
    rightStab.close();
    canvas.drawPath(rightStab, stabPaint);
    canvas.drawPath(rightStab, stabGlowPaint);

    // ── Vertical tail fin (top-view = slight diamond shape at rear centre) ──
    final finPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF2D3480).withValues(alpha: 0.7);
    final finGlowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = AppColors.airAccent.withValues(alpha: 0.4 + 0.3 * glow);

    final fin = Path();
    fin.moveTo(w / 2, h);
    fin.lineTo(w / 2 - 10, h * 0.5);
    fin.lineTo(w / 2, h * 0.4);
    fin.lineTo(w / 2 + 10, h * 0.5);
    fin.close();
    canvas.drawPath(fin, finPaint);
    canvas.drawPath(fin, finGlowPaint);

    // ── APU exhaust glow ──
    final apuPaint = Paint()
      ..color = AppColors.airAccent.withValues(alpha: 0.08 + 0.12 * glow)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(w / 2, h * 0.85), 16, apuPaint);

    // Centre stripe
    final stripePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = AppColors.airAccent.withValues(alpha: 0.12);
    canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, h * 0.7), stripePaint);
  }

  @override
  bool shouldRepaint(_TailPainter o) => o.glow != glow || o.shimmer != shimmer;
}

// ─── SEAT BUTTON ─────────────────────────────────────────────────────────────

class _SeatButton extends StatelessWidget {
  final String seatId;
  final _SeatStatus status;
  final _Zone zone;
  final AnimationController shimmerCtrl;
  final void Function(String) onTap;

  const _SeatButton({
    required this.seatId,
    required this.status,
    required this.zone,
    required this.shimmerCtrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOccupied = status == _SeatStatus.occupied;
    final isSelected = status == _SeatStatus.selected;

    Color bg;
    Color border;
    List<BoxShadow> shadows = [];

    if (isSelected) {
      bg = AppColors.airAccent;
      border = AppColors.airAccent;
      shadows = [
        BoxShadow(
          color: AppColors.airAccent.withValues(alpha: 0.6),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ];
    } else if (isOccupied) {
      bg = Colors.white.withValues(alpha: 0.06);
      border = Colors.white.withValues(alpha: 0.08);
    } else {
      switch (zone) {
        case _Zone.firstClass:
          bg = AppColors.airGold.withValues(alpha: 0.14);
          border = AppColors.airGold.withValues(alpha: 0.4);
          break;
        case _Zone.business:
          bg = AppColors.airAccent.withValues(alpha: 0.1);
          border = AppColors.airAccent.withValues(alpha: 0.3);
          break;
        case _Zone.economy:
          bg = const Color(0xFF1E2560);
          border = Colors.white.withValues(alpha: 0.18);
      }
    }

    return GestureDetector(
      onTap: isOccupied ? null : () => onTap(seatId),
      child: AnimatedContainer(
        duration: 200.ms,
        width: 28,
        height: 30,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: border, width: isSelected ? 1.5 : 1),
          boxShadow: shadows,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Headrest
            Container(
              width: 16,
              height: 7,
              decoration: BoxDecoration(
                color: isOccupied
                    ? Colors.white.withValues(alpha: 0.07)
                    : isSelected
                    ? Colors.white.withValues(alpha: 0.4)
                    : border.withValues(alpha: 0.5),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 2),
            // Seat base
            Container(
              width: 20,
              height: 8,
              decoration: BoxDecoration(
                color: isOccupied
                    ? Colors.white.withValues(alpha: 0.05)
                    : isSelected
                    ? Colors.white.withValues(alpha: 0.5)
                    : border,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SMALL WIDGETS ───────────────────────────────────────────────────────────

class _GlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

class _ZoneBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _ZoneBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: color.withValues(alpha: 0.85),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SeatLegend extends StatelessWidget {
  final Color color;
  final Color? border;
  final String label;
  const _SeatLegend({required this.color, this.border, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: border ?? color, width: 1.5),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }
}
