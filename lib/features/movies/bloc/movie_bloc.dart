import 'package:demo_app/features/movies/data/repo/movie_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  MovieBloc(this.repository) : super(const MovieInitial()) {
    on<FetchUpcomingMovies>(_onFetchUpcoming);
    on<FetchMovieDetails>(_onFetchDetails);
    on<SearchMovies>(_onSearchMovies);
    on<ToggleSearchBar>(_onToggleSearchBar);
  }

  void _onToggleSearchBar(ToggleSearchBar event, Emitter<MovieState> emit) {
    if (state is MovieListLoaded) {
      final s = state as MovieListLoaded;
      emit(MovieListLoaded(s.movies, isSearching: !s.isSearching));
    }
  }

  Future<void> _onFetchUpcoming(
    FetchUpcomingMovies event,
    Emitter<MovieState> emit,
  ) async {
    // Upcoming movies resets search state usually, or we can preserve it.
    // Assuming "FetchUpcoming" means "Go Home" or "Reset", let's reset isSearching to false.
    emit(const MovieLoading(isSearching: false));
    try {
      final movies = await repository.getUpcomingMovies();
      emit(MovieListLoaded(movies, isSearching: false));
    } catch (e) {
      emit(MovieError(e.toString(), isSearching: false));
    }
  }

  Future<void> _onFetchDetails(
    FetchMovieDetails event,
    Emitter<MovieState> emit,
  ) async {
    emit(MovieLoading(isSearching: state.isSearching));
    try {
      final movie = await repository.getMovieDetails(event.movieId);
      final trailerKey = await repository.getTrailerKey(event.movieId);

      emit(
        MovieDetailLoaded(
          movie,
          trailerKey: trailerKey,
          isSearching: state.isSearching,
        ),
      );
    } catch (e) {
      emit(MovieError(e.toString(), isSearching: state.isSearching));
    }
  }

  Future<void> _onSearchMovies(
    SearchMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading(isSearching: true));
    try {
      final movies = await repository.searchMovies(event.query);
      emit(MovieListLoaded(movies, isSearching: true));
    } catch (e) {
      emit(MovieError(e.toString(), isSearching: true));
    }
  }
}
