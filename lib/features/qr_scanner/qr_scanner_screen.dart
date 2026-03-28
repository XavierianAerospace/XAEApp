import 'package:flutter/material.dart';

class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escanear QR'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Simulación: QR Escaneado')),
            );
          },
          child: Text('Simular Escaneo'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ),
    );
  }
}
