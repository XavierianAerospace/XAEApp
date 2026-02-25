import 'package:flutter/material.dart';
import '../qr_scanner_screen.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final List<Map<String, dynamic>> dummyScannedItems = [
    {'nombre': 'Pieza 1', 'cantidad': 10},
    {'nombre': 'Pieza 2', 'cantidad': 5},
    {'nombre': 'Pieza 3', 'cantidad': 7},
  ];

  final List<Map<String, dynamic>> dummyRegisteredItems = [
    {'nombre': 'Pieza 1', 'codigo': 'PZ001', 'apartadoPor': 'Juan Pérez', 'fecha': DateTime(2026, 12, 10), 'cantidad': 2},
    {'nombre': 'Pieza 2', 'codigo': 'PZ002', 'apartadoPor': 'María López', 'fecha': DateTime(2026, 12, 12), 'cantidad': 1},
    {'nombre': 'Pieza 3', 'codigo': 'PZ003', 'apartadoPor': 'Juan Pérez', 'fecha': DateTime(2026  , 12, 13), 'cantidad': 3},
  ];

  String searchQueryLista = '';
  String searchQuery = '';
  String? selectedIntegrante;
  bool isViewingRegistered = false;

  @override
  Widget build(BuildContext context) {
    // Filtrar piezas por nombre en lista
    final filteredScannedItems = dummyScannedItems
        .where((item) => item['nombre'].toLowerCase().contains(searchQueryLista.toLowerCase()))
        .toList();

    // Filtrar piezas por nombre en registradas
    final filteredRegisteredItems = dummyRegisteredItems
        .where((item) =>
    (selectedIntegrante == null || item['apartadoPor'] == selectedIntegrante) &&
        item['nombre'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Color(0xff0a0a0f),
      appBar: AppBar(
        backgroundColor: Color(0xff0a0a0f),
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 35.0),
          child: Text(
            'Gestión de Piezas',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Botones de Lista y Registrados
            Padding(
              padding: EdgeInsets.only(top: 45.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildToggleButton('Lista de Piezas', false),
                  _buildToggleButton('Piezas Registradas', true),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Mostrar el buscador exclusivo para lista
            if (!isViewingRegistered)
              TextField(
                style: TextStyle(color: Color(0xffffffff)),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre de pieza...',
                  hintStyle: TextStyle(color: Color(0xffaaaaaa)),
                  filled: true,
                  fillColor: Color(0xff1a1a2e),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xff00ffff)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: Color(0xff00ffff), width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  prefixIcon: Icon(Icons.search, color: Color(0xff00ffff)),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQueryLista = value;
                  });
                },
              ),

            // Mostrar buscador y dropdown exclusivo para "Registrados"
            if (isViewingRegistered)
              Row(
                children: [
                  // Buscador de texto para "Registrados"
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: Color(0xffffffff)),
                      decoration: InputDecoration(
                        hintText: 'Buscar por nombre de pieza...',
                        hintStyle: TextStyle(color: Color(0xffaaaaaa)),
                        filled: true,
                        fillColor: Color(0xff1a1a2e),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xff00ffff)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Color(0xff00ffff), width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        prefixIcon: Icon(Icons.search, color: Color(0xff00ffff)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),

                  // Dropdown para seleccionar integrante
                  DropdownButton<String>(
                    value: selectedIntegrante,
                    hint: Text('Integrante', style: TextStyle(color: Color(0xffaaaaaa))),
                    dropdownColor: Color(0xff1a1a2e),
                    style: TextStyle(color: Color(0xffffffff)),
                    items: [
                      ...dummyRegisteredItems
                          .map((item) => item['apartadoPor'])
                          .toSet()
                          .map((integrante) {
                        return DropdownMenuItem<String>(
                          value: integrante,
                          child: Text(integrante),
                        );
                      }).toList()
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedIntegrante = value;
                      });
                    },
                  ),
                ],
              ),
            SizedBox(height: 20),

            // Lista de ítems
            Expanded(
              child: isViewingRegistered
                  ? ListView.builder(
                itemCount: filteredRegisteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredRegisteredItems[index];
                  return ListTile(
                    title: Text(
                      '${item['nombre']} (${item['codigo']})',
                      style: TextStyle(color: Color(0xffffffff)),
                    ),
                    subtitle: Text(
                      '${item['apartadoPor']}',
                      style: TextStyle(color: Color(0xffaaaaaa)),
                    ),
                    onTap: () => _showRegisteredItemDetails(context, item),
                  );
                },
              )
                  : ListView.builder(
                itemCount: filteredScannedItems.length,
                itemBuilder: (context, index) {
                  final item = filteredScannedItems[index];
                  return ListTile(
                    title: Text(item['nombre'], style: TextStyle(color: Color(0xffffffff))),
                    subtitle: Text(
                      'Cantidad disponible: ${item['cantidad']}',
                      style: TextStyle(color: Color(0xffaaaaaa)),
                    ),
                    onTap: () => _showAvailableItemDetails(context, item),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Boton floating para escanear QR
      floatingActionButton: FloatingActionButton(
        onPressed: _openQrScanner,
        backgroundColor: Color(0xff00ffff), // COlor primario cyan
        child: Icon(Icons.qr_code, color: Color(0xff0a0a0f)),
      ),
    );
  }

  // Botón de alternancia (Lista o Registrados)
  Widget _buildToggleButton(String text, bool viewRegistered) {
    final isSelected = isViewingRegistered == viewRegistered;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Color(0xff00ffff) : Color(0xffffaa00), // Cyan activo, amarillo inactivo
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      onPressed: () {
        setState(() {
          isViewingRegistered = viewRegistered;
          searchQuery = '';
          selectedIntegrante = null;
        });
      },
      child: Text(
        text,
        style: TextStyle(color: Color(0xff0a0a0f)), // Texto oscuro sobre botón claro
      ),
    );
  }

  // Mostrar detalles de un ítem disponible
  void _showAvailableItemDetails(BuildContext context, Map<String, dynamic> item) {
    final int piezasOcupadas = dummyRegisteredItems
        .where((e) => e['nombre'] == item['nombre'])
        .fold<int>(0, (sum, e) => sum + (e['cantidad'] as int));

    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xff1a1a2e), // Fondo de tarjetas
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalles del Ítem Disponible',
                style: TextStyle(color: Color(0xff00ffff), fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text('Nombre: ${item['nombre']}', style: TextStyle(color: Color(0xffffffff))),
              Text('Cantidad disponible: ${item['cantidad']}', style: TextStyle(color: Color(0xffffffff))),
              Text('Piezas ocupadas: $piezasOcupadas', style: TextStyle(color: Color(0xffffffff))),
            ],
          ),
        );
      },
    );
  }

  // Mostrar detalles de un ítem registrado
  void _showRegisteredItemDetails(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xff1a1a2e),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detalles del Ítem Registrado', style: TextStyle(color: Color(0xff00ffff), fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Nombre: ${item['nombre']}', style: TextStyle(color: Color(0xffffffff))),
              Text('Código: ${item['codigo']}', style: TextStyle(color: Color(0xffffffff))),
              Text('Apartado por: ${item['apartadoPor']}', style: TextStyle(color: Color(0xffffffff))),
              Text('Fecha de apartado: ${item['fecha']}', style: TextStyle(color: Color(0xffffffff))),
              Text('Cantidad apartada: ${item['cantidad']}', style: TextStyle(color: Color(0xffffffff))),
            ],
          ),
        );
      },
    );
  }

  void _openQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(),
      ),
    );
  }
}