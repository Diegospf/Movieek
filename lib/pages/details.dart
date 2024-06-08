import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movieek/services/movie_service.dart';

class DetailsPage extends StatefulWidget {
  final int movieId;

  const DetailsPage({super.key, required this.movieId});

  @override
  // ignore: library_private_types_in_public_api
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Map<String, dynamic> _movieDetails = {};
  bool _isInList = false;
  bool _isInGroupList = false;
  int _userRating = 0;
  List<Map<String, dynamic>> _groupRatings = [];
  double _groupRatingAverage = 0.0;
  bool _isLoadingDetails = true;
  bool _isLoadingRatings = true;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
    _fetchMovieRatings();
    _checkMovieInList();
    _checkMovieInGroupList();
  }

  Future<void> _fetchMovieDetails() async {
    try {
      final details = await MovieService().fetchMovieDetails(widget.movieId);
      setState(() {
        _movieDetails = details;
        _isLoadingDetails = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar detalhes do filme: $e');
      }
      setState(() {
        _isLoadingDetails = false;
      });
    }
  }

  Future<void> _fetchMovieRatings() async {
    try {
      final userRating =
          await MovieService().getUserRating('Diego', widget.movieId);
      final groupRatings =
          await MovieService().fetchMovieRatings(widget.movieId);
      final groupRatingAverage = groupRatings.isNotEmpty
          ? groupRatings
                  .map((rating) => rating['rate'] as int)
                  .reduce((a, b) => a + b) /
              groupRatings.length
          : 0.0;

      setState(() {
        // ignore: unnecessary_null_comparison
        _userRating = userRating != null ? userRating['rate'] : 0;
        _groupRatings = groupRatings;
        _groupRatingAverage = groupRatingAverage;
        _isLoadingRatings = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao buscar avaliações do filme: $e');
      }
      setState(() {
        _isLoadingRatings = false;
        _groupRatingAverage = 0.0;
      });
    }
  }

  Future<void> _checkMovieInList() async {
    try {
      final isInList =
          await MovieService().checkMovieInUserList('Diego', widget.movieId);
      setState(() {
        _isInList = isInList;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar se o filme está na lista do usuário: $e');
      }
    }
  }

  Future<void> _toggleMovieInList() async {
    try {
      if (_isInList) {
        await MovieService().removeMovieFromUserList('Diego', widget.movieId);
      } else {
        await MovieService().addMovieToUserList('Diego', widget.movieId);
      }
      setState(() {
        _isInList = !_isInList;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao modificar a lista de filmes do usuário: $e');
      }
    }
  }

  Future<void> _rateMovie(int rating) async {
    try {
      await MovieService().rateMovie('Diego', widget.movieId, rating);
      _fetchMovieRatings();
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao enviar avaliação: $e');
      }
    }
  }

  Future<void> _toggleGroupMovieInList() async {
    try {
      if (_isInGroupList) {
        await MovieService().removeMovieFromGroupList(widget.movieId);
      } else {
        await MovieService().addMovieToGroupList('Diego', widget.movieId);
      }
      setState(() {
        _isInGroupList = !_isInGroupList;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao modificar a lista de filmes do grupo: $e');
      }
    }
  }

  Future<void> _checkMovieInGroupList() async {
    try {
      final isInGroupList =
          await MovieService().checkMovieInGroupList('Diego', widget.movieId);
      setState(() {
        _isInGroupList = isInGroupList;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao verificar se o filme está na lista do grupo: $e');
      }
    }
  }

  Widget _buildStarRating() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _toggleMovieInList,
              icon: Icon(
                _isInList ? Icons.delete : Icons.add,
                color: Colors.white,
              ),
              label: const Text(
                'My List',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF602571),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _toggleGroupMovieInList,
              icon: Icon(
                _isInGroupList ? Icons.delete : Icons.add,
                color: Colors.white,
              ),
              label: const Text(
                'Group List',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(32, 80, 62, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'My Rating',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(10, (index) {
            return GestureDetector(
              onTap: () {
                _rateMovie(index + 1);
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.star_border,
                    color: Colors.white,
                    size: 30,
                  ),
                  if (index < _userRating)
                    const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 25,
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildGroupRatings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.public,
              color: Colors.white,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              'World Rating: ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              (_movieDetails['vote_average'] ?? 0.0).toStringAsFixed(1),
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.group,
              color: Colors.white,
            ),
            const SizedBox(
              width: 5,
            ),
            const Text(
              'Group Rating: ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _groupRatingAverage != 0.0
                  ? _groupRatingAverage.toStringAsFixed(1)
                  : '-',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_isLoadingRatings)
          const CircularProgressIndicator(
            color: Colors.white,
          )
        else if (_groupRatings.isEmpty)
          const Text(
            '',
            style: TextStyle(fontSize: 16, color: Colors.white),
          )
        else
          ..._groupRatings.map((rating) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  rating['user_id'],
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      rating['rate'].toString(),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            );
          }),
      ],
    );
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
        title: const Text(
          'Details',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoadingDetails
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 25),
                      width: 200,
                      height: 300,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF602571),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _movieDetails['poster_path'] != ''
                            ? Image.network(
                                'https://image.tmdb.org/t/p/w500${_movieDetails['poster_path']}',
                                fit: BoxFit.cover,
                              )
                            : const Placeholder(
                                fallbackHeight: 300,
                                fallbackWidth: 200,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _movieDetails['title'] ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Text(
                        _movieDetails['overview'] ?? '',
                        textAlign: TextAlign.justify,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildStarRating(),
                    const SizedBox(height: 20),
                    _buildGroupRatings(),
                  ],
                ),
              ),
            ),
    );
  }
}
