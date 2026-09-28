import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/sample_data.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> _filteredMovies = sampleMovies;
  final TextEditingController _searchController = TextEditingController();

  void _filterMovies(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMovies = sampleMovies;
      } else {
        _filteredMovies = sampleMovies
            .where((movie) =>
                movie.title.toLowerCase().contains(query.toLowerCase()) ||
                movie.genres.any((g) => g.toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Catalog'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterMovies,
              decoration: InputDecoration(
                hintText: 'Search movies by title or genre...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterMovies('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
            ),
          ),
          // Movie list
          Expanded(
            child: _filteredMovies.isEmpty
                ? const Center(
                    child: Text('No movies found', style: TextStyle(fontSize: 16)),
                  )
                : ListView.builder(
                    itemCount: _filteredMovies.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    itemBuilder: (context, index) {
                      final movie = _filteredMovies[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () async {
                            // Navigate to Detail Screen using Navigator.push + MaterialPageRoute
                            final updatedMovie = await Navigator.push<Movie>(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(movie: movie),
                              ),
                            );
                            if (updatedMovie != null) {
                              setState(() {
                                final idx = sampleMovies.indexWhere((m) => m.id == updatedMovie.id);
                                if (idx != -1) {
                                  sampleMovies[idx] = updatedMovie;
                                  _filterMovies(_searchController.text);
                                }
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                // Movie Poster thumbnail
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    movie.posterUrl,
                                    width: 70,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const SizedBox(
                                      width: 70,
                                      height: 100,
                                      child: Center(child: Icon(Icons.broken_image)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Movie Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${movie.releaseYear} • ${movie.genres.join(', ')}',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, color: Colors.amber, size: 18),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${movie.rating}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const Spacer(),
                                          if (movie.isFavorite)
                                            const Icon(Icons.favorite, color: Colors.red, size: 18),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
