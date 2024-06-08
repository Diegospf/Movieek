import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieService {
  final apiKey = dotenv.env['API_KEY'];
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String s32BaseUrl = 'https://s32-api-prisma.onrender.com';

  Future<List<dynamic>> fetchPopularMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception('Falha ao carregar filmes populares');
    }
  }

  Future<List<dynamic>> fetchSearchMovies(String query) async {
    final response = await http
        .get(Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['results'];
    } else {
      throw Exception('Falha ao carregar filmes da pesquisa');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar detalhes do filme');
    }
  }

  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$s32BaseUrl/user/'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar usuários');
    }
  }

  Future<List<dynamic>> fetchUserMovies(String userId) async {
    final response = await http.get(Uri.parse('$s32BaseUrl/rate/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> userMovies = jsonDecode(response.body);
      return userMovies;
    } else {
      throw Exception('Falha ao carregar filmes do usuário $userId');
    }
  }

  Future<List<int>> fetchMovieIds() async {
    final response = await http.get(Uri.parse('$s32BaseUrl/s32list/'));

    if (response.statusCode == 200) {
      List<dynamic> movieList = jsonDecode(response.body);
      return movieList.map<int>((movie) => movie['movie_id'] as int).toList();
    } else {
      throw Exception('Falha ao carregar lista de filmes');
    }
  }

  Future<List<int>> fetchIndividualMovieIds(String userId) async {
    final response = await http.get(Uri.parse('$s32BaseUrl/mylist/$userId'));

    if (response.statusCode == 200) {
      List<dynamic> movieList = jsonDecode(response.body);
      return movieList.map<int>((movie) => movie['movie_id'] as int).toList();
    } else {
      throw Exception('Falha ao carregar lista de filmes individual');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMoviesFromIds(
      List<int> movieIds) async {
    List<Map<String, dynamic>> movies = [];
    for (int id in movieIds) {
      try {
        Map<String, dynamic> movie = await fetchMovieDetails(id);
        movies.add(movie);
      } catch (e) {
        if (kDebugMode) {
          print('Falha ao carregar detalhes do filme $id: $e');
        }
      }
    }
    return movies;
  }

  Future<Map<String, dynamic>> getUserRating(String userId, int movieId) async {
    final response =
        await http.get(Uri.parse('$s32BaseUrl/rate/$userId/$movieId'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Falha ao carregar avaliação do usuário');
    }
  }

  Future<void> rateMovie(String userId, int movieId, int rating) async {
    final response = await http.post(
      Uri.parse('$s32BaseUrl/rate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'movie_id': movieId,
        'rate': rating,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Falha ao enviar avaliação');
    }
  }

  Future<List<Map<String, dynamic>>> fetchMovieRatings(int movieId) async {
    final response =
        await http.get(Uri.parse('$s32BaseUrl/rate/movie/$movieId'));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Falha ao carregar avaliações do filme');
    }
  }

  Future<bool> checkMovieInUserList(String userId, int movieId) async {
    final response =
        await http.get(Uri.parse('$s32BaseUrl/mylist/check/$userId/$movieId'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData['isInList'];
    } else {
      throw Exception('Falha ao verificar se o filme está na lista do usuário');
    }
  }

  Future<void> addMovieToUserList(String userId, int movieId) async {
    final response = await http.post(
      Uri.parse('$s32BaseUrl/mylist'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'movie_id': movieId.toString(),
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Falha ao adicionar filme à lista do usuário');
    }
  }

  Future<void> removeMovieFromUserList(String userId, int movieId) async {
    final response =
        await http.delete(Uri.parse('$s32BaseUrl/mylist/$userId/$movieId'));

    if (response.statusCode != 200) {
      throw Exception('Falha ao remover filme da lista do usuário');
    }
  }

  Future<bool> checkMovieInGroupList(String userId, int movieId) async {
    final response =
        await http.get(Uri.parse('$s32BaseUrl/s32list/check/$movieId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['isInList'] ?? false;
    } else {
      throw Exception('Falha ao verificar se o filme está na lista do grupo');
    }
  }

  Future<void> addMovieToGroupList(String userId, int movieId) async {
    final response = await http.post(
      Uri.parse('$s32BaseUrl/s32list'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': movieId,
        'movie_id': movieId,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Falha ao adicionar filme à lista do grupo');
    }
  }

  Future<void> removeMovieFromGroupList(int movieId) async {
    final response = await http.delete(
      Uri.parse('$s32BaseUrl/s32list/$movieId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao remover filme da lista do grupo');
    }
  }
}
