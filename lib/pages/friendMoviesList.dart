import 'package:flutter/material.dart';
import 'package:flutter_movieek/services/movie_service.dart';
import 'package:flutter_movieek/pages/details.dart';

class FriendMoviesListPage extends StatefulWidget {
  final String userId;

  const FriendMoviesListPage({required this.userId, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FriendMoviesListPageState createState() => _FriendMoviesListPageState();
}

class _FriendMoviesListPageState extends State<FriendMoviesListPage> {
  final MovieService movieService = MovieService();
  late Future<List<Map<String, dynamic>>> _futureFriendMoviesList;

  @override
  void initState() {
    super.initState();
    _futureFriendMoviesList = fetchUserMoviesWithDetails(widget.userId);
  }

  Future<List<Map<String, dynamic>>> fetchUserMoviesWithDetails(
      String userId) async {
    List<dynamic> userMovies = await movieService.fetchUserMovies(userId);
    List<Map<String, dynamic>> moviesWithDetails = [];

    for (var movie in userMovies) {
      var movieDetails =
          await movieService.fetchMovieDetails(movie['movie_id']);
      movieDetails['rate'] = movie['rate'];
      moviesWithDetails.add(movieDetails);
    }

    return moviesWithDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          '${widget.userId}\'s Rates',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureFriendMoviesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>>? movies = snapshot.data;
            return ListView.builder(
              itemCount: movies!.length,
              itemBuilder: (context, index) {
                var movie = movies[index];
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: movie['poster_path'] != null
                        ? Image.network(
                            'https://image.tmdb.org/t/p/w92${movie['poster_path']}',
                            fit: BoxFit.cover,
                            width: 50,
                          )
                        : null,
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            movie['title'],
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                movie['rate'].toString(),
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
