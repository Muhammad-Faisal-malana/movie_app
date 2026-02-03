import 'package:demo_app/core/utils/app_loading_indicator.dart';
import 'package:demo_app/features/movies/bloc/movie_event.dart';
import 'package:demo_app/features/movies/bloc/movie_state.dart';
import 'package:demo_app/features/movies/widget/movie_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_bloc.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchUpcomingMovies());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.isNotEmpty) {
      context.read<MovieBloc>().add(SearchMovies(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieBloc, MovieState>(
      listener: (context, state) {
        if (!state.isSearching) {
          _searchController.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: state.isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search movies...',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    onChanged: _onSearchChanged,
                  )
                : const Text('Upcoming Movies'),
            actions: [
              if (state is! MovieError && state is! MovieLoading)
                IconButton(
                  icon: Icon(state.isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    if (state.isSearching) {
                      context.read<MovieBloc>().add(FetchUpcomingMovies());
                    } else {
                      context.read<MovieBloc>().add(ToggleSearchBar());
                    }
                  },
                ),
            ],
          ),
          body: Builder(
            builder: (context) {
              if (state is MovieLoading) {
                return const AppLoadingIndicator();
              }

              if (state is MovieListLoaded) {
                if (state.movies.isEmpty) {
                  return const Center(
                    child: Text(
                      'No movies found',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.movies.length,
                  physics: const BouncingScrollPhysics(),
                  addRepaintBoundaries: false,
                  addAutomaticKeepAlives: false,
                  
                  itemBuilder: (_, index) {
                    final movie = state.movies[index];
                    return MovieCard(movie: movie);
                  },
                );
              }

              if (state is MovieError) {
                return Center(child: Text(state.message));
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
