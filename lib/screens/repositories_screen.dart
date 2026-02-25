import 'package:flutter/material.dart';

class RepositoriesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _repos = [
    {
      'name': 'rover-navigation',
      'description': 'Sistema de navegación autónoma',
      'language': 'Python',
      'stars': 45,
    },
    {
      'name': 'control-interface',
      'description': 'Interfaz de control del rover',
      'language': 'Flutter',
      'stars': 32,
    },
    {
      'name': 'sensor-integration',
      'description': 'Integración de sensores lidar',
      'language': 'C++',
      'stars': 28,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff1a1a2e),
        foregroundColor: Color(0xffffffff),
        title: Text('Repositorios GitHub'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _repos.length,
        itemBuilder: (context, index) {
          final repo = _repos[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xff1a1a2e),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xff00ffff).withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.code, color: Color(0xff00ffff)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        repo['name'],
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  repo['description'],
                  style: TextStyle(color: Color(0xffaaaaaa)),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xff00ffff).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        repo['language'],
                        style: TextStyle(color: Color(0xff00ffff), fontSize: 12),
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.star, color: Color(0xffffaa00), size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${repo['stars']}',
                      style: TextStyle(color: Color(0xffaaaaaa)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}