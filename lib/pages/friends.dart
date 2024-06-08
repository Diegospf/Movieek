import 'package:flutter/material.dart';
import 'package:flutter_movieek/pages/friendMoviesList.dart';
import '../services/movie_service.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final MovieService movieService = MovieService();
  late Future<List<UserData>> _futureUsersData;

  @override
  void initState() {
    super.initState();
    _futureUsersData = fetchUsersData();
  }

  Future<List<UserData>> fetchUsersData() async {
    List<dynamic> users = await movieService.fetchUsers();
    List<UserData> usersData = [];

    for (var user in users) {
      String userId = user['id'];
      List<dynamic> userMovies = (await movieService.fetchUserMovies(userId));
      int moviesCount = userMovies.length;
      usersData.add(UserData(id: userId, moviesCount: moviesCount));
    }

    return usersData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212),
              Color(0xFF602571),
            ],
          ),
        ),
        child: FutureBuilder<List<UserData>>(
          future: _futureUsersData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<UserData>? usersData = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Members',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: usersData!.map((user) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: MemberCard(
                          name: user.id,
                          moviesCount: user.moviesCount,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class UserData {
  final String id;
  final int moviesCount;

  UserData({required this.id, required this.moviesCount});
}

class MemberCard extends StatelessWidget {
  final String name;
  final int moviesCount;

  const MemberCard({required this.name, required this.moviesCount, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendMoviesListPage(userId: name),
          ),
        );
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.movie, color: Colors.white),
                const SizedBox(width: 5),
                Text(
                  moviesCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
