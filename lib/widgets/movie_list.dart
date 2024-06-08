import 'package:flutter/material.dart';
import 'package:flutter_movieek/pages/details.dart';

class MovieListView extends StatelessWidget {
  final List<dynamic> searchResults;

  const MovieListView({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
      child: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final movie = searchResults[index];
          final posterPath = movie['poster_path'];

          if (posterPath == null || posterPath.isEmpty) {
            return const SizedBox();
          }
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(
                    movieId: movie['id'],
                  ),
                ),
              );
            },
            child: Column(
              children: [
                Image.network(
                  'https://image.tmdb.org/t/p/w500$posterPath',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                const SizedBox(height: 15),
                Text(
                  movie['title'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 55),
                // Adicione outras informações do filme conforme necessário
              ],
            ),
          );
        },
      ),
    );
  }
}
