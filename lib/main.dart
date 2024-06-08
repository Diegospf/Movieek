import 'package:flutter/material.dart';
import 'package:flutter_movieek/pages/friends.dart';
import 'package:flutter_movieek/pages/home.dart';
import 'package:flutter_movieek/pages/list.dart';
import 'package:flutter_movieek/pages/popular.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(
            0xFF000000,
            <int, Color>{
              50: Colors.black,
              100: Colors.black,
              200: Colors.black,
              300: Colors.black,
              400: Colors.black,
              500: Colors.black,
              600: Colors.black,
              700: Colors.black,
              800: Colors.black,
              900: Colors.black,
            },
          ),
        ),
      ),
      home: const BottomNavBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const HomePage(),
    const PopularPage(),
    const HomePage(),
    const FriendsPage(),
    const ListPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: '',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.purple,
      ),
    );
  }
}
