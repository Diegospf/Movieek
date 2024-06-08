import 'package:flutter/material.dart';
import 'package:flutter_movieek/services/movie_service.dart';
import 'package:flutter_movieek/widgets/movie_list.dart';

class SearchPage extends StatefulWidget {
  final String query;

  const SearchPage({super.key, required this.query});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _controller;
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.query);
    _searchMovies(widget.query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _searchMovies(String query) async {
    try {
      final List<dynamic> results =
          await MovieService().fetchSearchMovies(query);
      setState(() {
        _searchResults = results;
      });
      _controller.text = query;
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao buscar filmes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: TextField(
                      textInputAction: TextInputAction.search,
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                        hintText: 'Search a movie...',
                        hintStyle: TextStyle(color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onSubmitted: (value) {
                        _searchMovies(value);
                      },
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                _searchMovies(_controller.text);
              },
            ),
          ],
        ),
      ),
      body: MovieListView(searchResults: _searchResults),
    );
  }
}
