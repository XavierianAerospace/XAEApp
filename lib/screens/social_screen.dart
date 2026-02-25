import 'package:flutter/material.dart';

class SocialScreen extends StatelessWidget {
  final List<Map<String, String>> _socials = [
    {'name': 'Instagram', 'handle': '@xae_javeriana', 'icon': 'instagram'},
    {'name': 'Twitter', 'handle': '@xae_javeri ana', 'icon': 'twitter'},
    {'name': 'LinkedIn', 'handle': 'XAE Javeriana', 'icon': 'linkedin'},
    {'name': 'YouTube', 'handle': 'XAE Semillero', 'icon': 'youtube'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff1a1a2e),
        foregroundColor: Color(0xffffffff),
        title: Text('Redes Sociales'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _socials.length,
        itemBuilder: (context, index) {
          final social = _socials[index];
          return Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xff1a1a2e),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xff00ffff).withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xff00ffff).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(Icons.share, color: Color(0xff00ffff)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        social['name']!,
                        style: TextStyle(color: Color(0xffffffff), fontWeight: FontWeight.bold),
                      ),
                      Text(
                        social['handle']!,
                        style: TextStyle(color: Color(0xffaaaaaa), fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Color(0xffaaaaaa), size: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}