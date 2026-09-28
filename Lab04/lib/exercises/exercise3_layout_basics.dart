import 'package:flutter/material.dart';

/// Exercise 3 – Layout Basics: Column, Row, Padding, ListView
/// Goal: Build a sectioned UI layout similar to a real app Home screen.
class Exercise3Screen extends StatelessWidget {
  const Exercise3Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> movieTitles = [
      'The Dark Knight',
      'Inception',
      'Interstellar',
      'Avengers: Endgame',
      'Spider-Man: Into the Spider-Verse',
      'Parasite',
      'Whiplash',
      'The Matrix',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3: Layout Basics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section using Row & Padding
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'See All',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ListView.builder inside Expanded to avoid layout unbounded height error
            Expanded(
              child: ListView.builder(
                itemCount: movieTitles.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.primaries[index % Colors.primaries.length],
                        child: Text('${index + 1}'),
                      ),
                      title: Text(movieTitles[index]),
                      subtitle: const Text('Action / Sci-Fi • 2023'),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
