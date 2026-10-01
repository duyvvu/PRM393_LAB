import 'package:flutter/material.dart';

// ────────────────────────────────────────────────────────────────────────────
// Lab 6 – Building a Responsive Movie Genre Browsing Screen
//
// This single-file Flutter app demonstrates:
//   • MediaQuery / LayoutBuilder for responsive breakpoints
//   • SafeArea to handle notches / camera cutouts
//   • Wrap widget for genre chips
//   • Filtering by search text and genre selection
//   • Sorting (A-Z, Z-A, Year, Rating)
//   • Adaptive layout: single-column list (< 800 px) vs 2-column grid (≥ 800 px)
// ────────────────────────────────────────────────────────────────────────────

void main() {
  runApp(const ResponsiveMovieApp());
}

// ===========================================================================
// Movie model
// ===========================================================================

/// A simple data class representing a movie.
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

// ===========================================================================
// Sample data – 6 movies with various genres
// ===========================================================================

const List<Movie> allMovies = [
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/darkknight/200/300',
    rating: 9.0,
  ),
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Thriller'],
    posterUrl: 'https://picsum.photos/seed/inception/200/300',
    rating: 8.8,
  ),
  Movie(
    title: 'The Shawshank Redemption',
    year: 1994,
    genres: ['Drama'],
    posterUrl: 'https://picsum.photos/seed/shawshank/200/300',
    rating: 9.3,
  ),
  Movie(
    title: 'Superbad',
    year: 2007,
    genres: ['Comedy'],
    posterUrl: 'https://picsum.photos/seed/superbad/200/300',
    rating: 7.6,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama', 'Adventure'],
    posterUrl: 'https://picsum.photos/seed/interstellar/200/300',
    rating: 8.6,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://picsum.photos/seed/hangover/200/300',
    rating: 7.7,
  ),
];

// ===========================================================================
// Root application widget
// ===========================================================================

/// The root MaterialApp for the responsive movie browsing demo.
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 6 – Responsive Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const GenreScreen(),
    );
  }
}

// ===========================================================================
// GenreScreen – the main stateful screen
// ===========================================================================

/// The primary screen that contains search, genre chips, sort bar, and the
/// responsive movie list.
class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  // ── State variables ──────────────────────────────────────────────────────

  /// Current search text entered by the user.
  String searchQuery = '';

  /// Currently selected genre filters.
  final Set<String> selectedGenres = {};

  /// Current sort option (A-Z, Z-A, Year, Rating).
  String selectedSort = 'A-Z';

  /// All available genres (derived from the sample data).
  final List<String> genres = [
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Sci-Fi',
    'Thriller',
  ];

  /// Available sort options.
  final List<String> sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating'];

  // ── Filtering & sorting logic ────────────────────────────────────────────

  /// Returns the list of movies filtered by [searchQuery] and
  /// [selectedGenres], then sorted by [selectedSort].
  List<Movie> get visibleMovies {
    // 1. Filter by search query (case-insensitive title match).
    List<Movie> filtered = allMovies.where((movie) {
      final matchesSearch =
          movie.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    // 2. Filter by selected genres (movie must contain at least one).
    if (selectedGenres.isNotEmpty) {
      filtered = filtered.where((movie) {
        return movie.genres.any((g) => selectedGenres.contains(g));
      }).toList();
    }

    // 3. Sort according to the chosen option.
    switch (selectedSort) {
      case 'A-Z':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Z-A':
        filtered.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Year':
        filtered.sort((a, b) => a.year.compareTo(b.year));
        break;
      case 'Rating':
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }

    return filtered;
  }

  // ── Clear filters helper ─────────────────────────────────────────────────

  /// Resets all filters and sort to defaults.
  void _clearFilters() {
    setState(() {
      searchQuery = '';
      selectedGenres.clear();
      selectedSort = 'A-Z';
    });
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final movies = visibleMovies;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title heading ──────────────────────────────────────────
              _buildTitle(),

              const SizedBox(height: 12),

              // ── Search bar ─────────────────────────────────────────────
              _buildSearchBar(),

              const SizedBox(height: 12),

              // ── Genre chips ────────────────────────────────────────────
              _buildGenreChips(),

              const SizedBox(height: 8),

              // ── Sort bar & badge ───────────────────────────────────────
              _buildSortBar(),

              const SizedBox(height: 12),

              // ── Movie list / grid (responsive) ─────────────────────────
              Expanded(
                child: movies.isEmpty
                    ? const Center(
                        child: Text(
                          'No movies match your filters.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : _buildResponsiveMovieList(movies),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── UI component builders ──────────────────────────────────────────────

  /// Builds the page title with a "Clear filters" action.
  Widget _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Find a Movie',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        // Bonus: Clear filters button
        if (selectedGenres.isNotEmpty || searchQuery.isNotEmpty)
          TextButton.icon(
            onPressed: _clearFilters,
            icon: const Icon(Icons.clear_all, size: 20),
            label: const Text('Clear filters'),
          ),
      ],
    );
  }

  /// Builds a rounded search bar using a [TextField].
  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search movies...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  /// Builds horizontally-wrapping genre filter chips using [Wrap].
  Widget _buildGenreChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section label with optional badge showing number of selected genres
        Row(
          children: [
            const Text(
              'Genres',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            if (selectedGenres.isNotEmpty) ...[
              const SizedBox(width: 8),
              // Bonus: badge with count of selected genres
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selectedGenres.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Wrap widget ensures chips flow to the next line on narrow screens
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: genres.map((genre) {
            final isSelected = selectedGenres.contains(genre);
            return FilterChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    selectedGenres.add(genre);
                  } else {
                    selectedGenres.remove(genre);
                  }
                });
              },
              selectedColor:
                  Theme.of(context).colorScheme.primaryContainer,
              checkmarkColor:
                  Theme.of(context).colorScheme.onPrimaryContainer,
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Builds the sort dropdown row.
  Widget _buildSortBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${visibleMovies.length} movie${visibleMovies.length == 1 ? '' : 's'} found',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Row(
          children: [
            const Text('Sort: ', style: TextStyle(fontSize: 14)),
            DropdownButton<String>(
              value: selectedSort,
              underline: const SizedBox.shrink(),
              items: sortOptions.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedSort = value;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  /// Builds a responsive movie list that switches between a single-column
  /// [ListView] (width < 800) and a two-column [GridView] (width ≥ 800)
  /// using [LayoutBuilder].
  Widget _buildResponsiveMovieList(List<Movie> movies) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;

        if (isWide) {
          // ── Tablet / wide web: two-column grid ──────────────────────
          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.8,
            children: movies.map((movie) {
              return _MovieCard(movie: movie, isWideLayout: true);
            }).toList(),
          );
        } else {
          // ── Phone: single-column list ───────────────────────────────
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _MovieCard(movie: movies[index], isWideLayout: false),
              );
            },
          );
        }
      },
    );
  }
}

// ===========================================================================
// _MovieCard – individual movie display card
// ===========================================================================

/// Displays a single movie's poster, title, year, and rating inside a
/// Material card. Uses [LayoutBuilder] to adapt poster size.
class _MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isWideLayout;

  const _MovieCard({required this.movie, required this.isWideLayout});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Adapt poster width based on available card width
          final posterWidth = isWideLayout
              ? constraints.maxWidth * 0.25
              : constraints.maxWidth * 0.22;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Poster image ───────────────────────────────────────────
              SizedBox(
                width: posterWidth,
                height: isWideLayout ? 130 : 140,
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.movie, size: 40),
                  ),
                ),
              ),

              // ── Movie details ──────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Year
                      Text(
                        '${movie.year}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Genre tags
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: movie.genres.map((g) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              g,
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 6),

                      // Bonus: Rating displayed as stars + numeric text
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            final starValue = index + 1;
                            final halfRating = movie.rating / 2;
                            if (starValue <= halfRating) {
                              return const Icon(Icons.star,
                                  size: 16, color: Colors.amber);
                            } else if (starValue - 0.5 <= halfRating) {
                              return const Icon(Icons.star_half,
                                  size: 16, color: Colors.amber);
                            } else {
                              return const Icon(Icons.star_border,
                                  size: 16, color: Colors.amber);
                            }
                          }),
                          const SizedBox(width: 4),
                          Text(
                            '${movie.rating}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
