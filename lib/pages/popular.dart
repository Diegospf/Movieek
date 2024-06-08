import 'package:flutter/material.dart';
import 'package:flutter_movieek/services/movie_service.dart';
import 'package:flutter_movieek/widgets/movie_list.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PopularPageState createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage> {
  late List<dynamic> _popularResults = [];

  @override
  void initState() {
    super.initState();
    _fetchPopularMovies();
  }

  Future<void> _fetchPopularMovies() async {
    try {
      final List results = await MovieService().fetchPopularMovies();
      setState(() {
        _popularResults = results;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao buscar filmes populares: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            'Popular',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: _popularResults.isNotEmpty
          ? MovieListView(searchResults: _popularResults)
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
    );
  }
}
