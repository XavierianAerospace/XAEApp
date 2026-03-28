import 'package:flutter/material.dart';

class AddHoursScreen extends StatelessWidget {
  const AddHoursScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Agregar Horas'),
      ),
      body: Center(
        child: Text(
          'Aquí irá el lector de QR',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
