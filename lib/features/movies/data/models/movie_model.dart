class MovieModel {
  final int id;
  final String title;
  final String posterPath;
  final String releaseDate;

  MovieModel({
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
}
