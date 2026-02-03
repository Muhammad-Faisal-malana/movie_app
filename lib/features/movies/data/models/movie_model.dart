import 'package:equatable/equatable.dart';

class MovieModel extends Equatable {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;

  const MovieModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, title, posterPath, releaseDate];
}
