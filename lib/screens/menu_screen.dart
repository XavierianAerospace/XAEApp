import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'projects_screen.dart';
import 'tasks_screen.dart';
import 'more_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProjectsScreen(),
    TasksScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xff00ffff),
        unselectedItemColor: Color(0xffaaaaaa),
        backgroundColor: Color(0xff0a0a0f),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Proyectos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Más',
          ),
        ],
      ),
    );
  }
}