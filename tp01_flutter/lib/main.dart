import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FLUTTER_TP_Jules',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 37, 51)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BTS SIO Fenelon'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Ajouter un TextEditingController : Location
  final TextEditingController _checkText = TextEditingController();
  String _location = ""; // Pour stocker le texte saisi
  LatLng _currentLatLng = LatLng(46.166667,-1.15000048); // Coordonnées par défaut (Paris)

  // Méthode pour valider la localisation
  void _submitLocation() {
    setState(() {
      _location = _checkText.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Input pour : location
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _checkText,
              decoration: const InputDecoration(
                labelText: "Entrez une adresse",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitLocation,
            child: const Text('Valider'),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _currentLatLng, // Coordonnées dynamiques
                initialZoom: 13.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
