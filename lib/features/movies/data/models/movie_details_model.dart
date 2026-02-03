class MovieDetailModel {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final int runtime;
  final double voteAverage;
  final int voteCount;
  final String status;
  final String tagline;
  final String homepage;
  final bool adult;

  final List<Genre> genres;
  final List<ProductionCompany> productionCompanies;
  final List<String> spokenLanguages;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.runtime,
    required this.voteAverage,
    required this.voteCount,
    required this.status,
    required this.tagline,
    required this.homepage,
    required this.adult,
    required this.genres,
    required this.productionCompanies,
    required this.spokenLanguages,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'],
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      runtime: json['runtime'] ?? 0,
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      homepage: json['homepage'] ?? '',
      adult: json['adult'] ?? false,
      genres: (json['genres'] as List? ?? [])
          .map((e) => Genre.fromJson(e))
          .toList(),
      productionCompanies:
          (json['production_companies'] as List? ?? [])
              .map((e) => ProductionCompany.fromJson(e))
              .toList(),
      spokenLanguages:
          (json['spoken_languages'] as List? ?? [])
              .map((e) => e['english_name'].toString())
              .toList(),
    );
  }
}
class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}
class ProductionCompany {
  final int id;
  final String name;
  final String logoPath;
  final String originCountry;

  ProductionCompany({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      id: json['id'],
      name: json['name'] ?? '',
      logoPath: json['logo_path'] ?? '',
      originCountry: json['origin_country'] ?? '',
    );
  }
}
