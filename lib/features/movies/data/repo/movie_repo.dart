import 'package:demo_app/core/services/api_base_client.dart';
import 'package:demo_app/features/movies/data/models/movie_details_model.dart';
import 'package:dio/dio.dart';

import '../models/movie_model.dart';
import '../models/movie_video_model.dart';

class MovieRepository {
  final Dio dio = DioClient.create();

  Future<List<MovieModel>> getUpcomingMovies() async {
    final response = await dio.get('/movie/upcoming');

    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }

  Future<MovieDetailModel> getMovieDetails(int id) async {
    final response = await dio.get('/movie/$id');
    return MovieDetailModel.fromJson(response.data);
  }

  Future<String?> getTrailerKey(int id) async {
    final response = await dio.get('/movie/$id/videos');

    final videos = (response.data['results'] as List)
        .map((e) => VideoModel.fromJson(e))
        .where((v) => v.type == 'Trailer')
        .toList();

    return videos.isNotEmpty ? videos.first.key : null;
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await dio.get(
      '/search/movie',
      queryParameters: {'query': query},
    );

    return (response.data['results'] as List)
        .map((e) => MovieModel.fromJson(e))
        .toList();
  }
}
