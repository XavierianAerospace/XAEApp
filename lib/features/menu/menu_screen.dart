import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../inventory/inventory_screen.dart';
import '../pending/pending_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),
      const PendingScreen(),
      const InventoryScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          _buildAnimatedItem(Icons.home, 'Inicio', 0),
          _buildAnimatedItem(Icons.list_alt, 'Pendientes', 1),
          _buildAnimatedItem(Icons.widgets_outlined, 'Inventario', 2),
          _buildAnimatedItem(Icons.person, 'Perfil', 3),
        ],
      ),
    );
  }

  /// Método para crear los ítems animados
  BottomNavigationBarItem _buildAnimatedItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: TweenAnimationBuilder(
        tween:
            Tween<double>(begin: 1.0, end: _currentIndex == index ? 1.2 : 1.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Icon(
              icon,
              color: _currentIndex == index ? Colors.white : Colors.grey,
            ),
          );
        },
      ),
      label: label,
    );
  }
}
