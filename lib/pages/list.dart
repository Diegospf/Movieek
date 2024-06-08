import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movieek/services/movie_service.dart';
import 'package:flutter_movieek/widgets/movie_list.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  late List<dynamic> _movieResults = [];
  bool _isGroupList = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future<void> _fetchMovies() async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<int> movieIds;
      if (_isGroupList) {
        movieIds = await MovieService().fetchMovieIds();
      } else {
        movieIds = await MovieService().fetchIndividualMovieIds('Diego');
      }
      final List<Map<String, dynamic>> results =
          await MovieService().fetchMoviesFromIds(movieIds);
      setState(() {
        _movieResults = results;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar filmes: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleList() {
    setState(() {
      _isGroupList = !_isGroupList;
      _fetchMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Stack(
          children: [
            Center(
              child: Text(
                _isGroupList ? 'Group List' : 'My List',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(_isGroupList ? Icons.person : Icons.group,
                    color: Colors.white),
                onPressed: _toggleList,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : _movieResults.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 60,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'No films in the list',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : MovieListView(searchResults: _movieResults),
    );
  }
}
