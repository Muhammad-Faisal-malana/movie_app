import 'package:demo_app/core/bloc/connectivity_bloc.dart';
import 'package:demo_app/core/common_widget/connectivity_wrapper.dart';
import 'package:demo_app/features/flight_booking/presentation/flight_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ConnectivityBloc())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SkyBook – Airline Booking',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF0F1135),
          textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF4FC3F7),
            secondary: Color(0xFFFFD54F),
          ),
        ),
        builder: (context, child) {
          return ConnectivityWrapper(child: child!);
        },
        home: const FlightHomeScreen(),
      ),
    );
  }
}
