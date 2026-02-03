import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUpcomingMovies extends MovieEvent {}

class FetchMovieDetails extends MovieEvent {
  final int movieId;
  FetchMovieDetails(this.movieId);
}

class SearchMovies extends MovieEvent {
  final String query;
  SearchMovies(this.query);
}

class ToggleSearchBar extends MovieEvent {}
