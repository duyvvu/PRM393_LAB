class Trailer {
  final String id;
  final String title;
  final String thumbnailUrl;

  const Trailer({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });
}

class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final int releaseYear;
  final List<Trailer> trailers;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.releaseYear,
    required this.trailers,
    this.isFavorite = false,
  });
}
