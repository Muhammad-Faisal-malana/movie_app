import 'package:demo_app/core/bloc/connectivity_bloc.dart';
import 'package:demo_app/core/common_widget/connectivity_wrapper.dart';
import 'package:demo_app/features/movies/data/repo/movie_repo.dart';
import 'package:demo_app/features/movies/presentation/movie_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/movies/bloc/movie_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => MovieBloc(MovieRepository())),
        BlocProvider(create: (_) => ConnectivityBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie App',
        theme: ThemeData.dark(),
        builder: (context, child) {
          return ConnectivityWrapper(child: child!);
        },
        home: const MovieListScreen(),
      ),
    );
  }
}
