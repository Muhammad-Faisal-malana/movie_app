import 'package:demo_app/features/movies/data/models/movie_details_model.dart';
import 'package:equatable/equatable.dart';
import '../data/models/movie_model.dart';

abstract class MovieState extends Equatable {
  final bool isSearching;

  const MovieState({this.isSearching = false});

  @override
  List<Object?> get props => [isSearching];
}

class MovieInitial extends MovieState {
  const MovieInitial({super.isSearching});
}

class MovieLoading extends MovieState {
  const MovieLoading({super.isSearching});
}

class MovieListLoaded extends MovieState {
  final List<MovieModel> movies;

  const MovieListLoaded(this.movies, {super.isSearching});

  @override
  List<Object?> get props => [movies, isSearching];
}

class MovieDetailLoaded extends MovieState {
  final MovieDetailModel movie;
  final String? trailerKey;

  const MovieDetailLoaded(this.movie, {this.trailerKey, super.isSearching});

  @override
  List<Object?> get props => [movie, trailerKey, isSearching];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message, {super.isSearching});

  @override
  List<Object?> get props => [message, isSearching];
}
