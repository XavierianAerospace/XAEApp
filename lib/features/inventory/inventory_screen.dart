import 'package:flutter/material.dart';
import '../qr_scanner/qr_scanner_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Map<String, dynamic>> _scannedItems = [];
  final List<Map<String, dynamic>> _registeredItems = [];
  final bool _isLoading = false;

  String searchQueryLista = '';
  String searchQuery = '';
  String? selectedIntegrante;
  bool isViewingRegistered = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }

    List<Map<String, dynamic>> itemsToShow = isViewingRegistered
        ? _registeredItems
            .where((item) => item['nombre']
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList()
        : _scannedItems
            .where((item) => item['nombreItem']
                .toString()
                .toLowerCase()
                .contains(searchQueryLista.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Inventario',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !isViewingRegistered ? Colors.red : Colors.grey[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      isViewingRegistered = false;
                    });
                  },
                  child: Text('Escaneado',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isViewingRegistered ? Colors.red : Colors.grey[800],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      isViewingRegistered = true;
                    });
                  },
                  child: Text('Registrado',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (!isViewingRegistered)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtrar por nombre:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar artículo escaneado...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQueryLista = value;
                      });
                    },
                  ),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtrar por nombre:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar artículo registrado...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ],
              ),
            SizedBox(height: 20),
            Expanded(
              child: itemsToShow.isEmpty
                  ? Center(
                      child: Text(
                        'No hay elementos para mostrar',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: itemsToShow.length,
                      itemBuilder: (context, index) {
                        final item = itemsToShow[index];
                        return Card(
                          color: Colors.grey[800],
                          child: ListTile(
                            title: Text(
                              isViewingRegistered
                                  ? item['nombre']
                                  : item['nombreItem'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              isViewingRegistered
                                  ? 'Responsable: ${item['responsable']}'
                                  : 'Cantidad: ${item['cantidad']}',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: !isViewingRegistered
          ? FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QRScannerScreen()),
                );
              },
              child: Icon(Icons.camera_alt, color: Colors.white),
            )
          : null,
    );
  }
}
