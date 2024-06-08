import 'package:flutter/material.dart';
import 'search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToSearchPage(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SearchPage(query: query)),
    );
  }

  void _search() {
    String query = _controller.text;
    _navigateToSearchPage(query);
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Movieek',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
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
                  child: Row(
                    children: [
                      Expanded(
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
                          onSubmitted: (value) => _search(),
                        ),
                      ),
                      GestureDetector(
                        onTap: _search,
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
