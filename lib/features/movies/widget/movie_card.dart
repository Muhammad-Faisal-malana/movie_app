import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_app/core/common_widget/custom_newtork_image.dart';
import 'package:demo_app/core/services/api_config.dart';
import 'package:demo_app/features/movies/presentation/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../data/models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Movie Detail Screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailScreen(movieId: movie.id),
          ),
        );
      },
      child: Container(
        height: 280, // Adjust height as needed
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Stack(
          children: [
            // Movie Poster Image with Shimmer Loading
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedImageWithShimmer.buildWithShimmer(
                imageUrl: '${ApiConfig.imageBaseUrl}${movie.posterPath}',
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            // Gradient Overlay for text readability
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),

            // Title & Release Date
            Positioned(
              left: 16,
              bottom: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   movie.releaseDate,
                  //   style: const TextStyle(color: Colors.white70, fontSize: 14),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
