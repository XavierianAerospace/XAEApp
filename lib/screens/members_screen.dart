import 'package:flutter/material.dart';

class MembersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _members = [
    {'name': 'Juan Pérez', 'role': 'Líder Técnico', 'subsystem': 'Mecánica', 'hours': 120},
    {'name': 'María López', 'role': 'Desarrolladora', 'subsystem': 'Programación', 'hours': 95},
    {'name': 'Carlos García', 'role': 'Ingeniero', 'subsystem': 'Electrónica', 'hours': 110},
    {'name': 'Ana Torres', 'role': 'Diseñadora', 'subsystem': 'Mecánica', 'hours': 85},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff1a1a2e),
        foregroundColor: Color(0xffffffff),
        title: Text('Integrantes'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xff1a1a2e),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xff00ffff).withValues(alpha: 0.3), width: 1),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xff00ffff),
                  child: Text(
                    member['name'][0],
                    style: TextStyle(color: Color(0xff0a0a0f), fontSize: 24),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member['name'],
                        style: TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        member['role'],
                        style: TextStyle(color: Color(0xffaaaaaa), fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.folder, size: 14, color: Color(0xff00ffff)),
                          SizedBox(width: 4),
                          Text(
                            member['subsystem'],
                            style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.access_time, size: 14, color: Color(0xff00ffff)),
                          SizedBox(width: 4),
                          Text(
                            '${member['hours']}h',
                            style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}