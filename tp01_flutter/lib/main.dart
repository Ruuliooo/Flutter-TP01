import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert'; // Pour décoder la réponse JSON
import 'package:http/http.dart' as http; // Pour effectuer des requêtes HTTP

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
      home: const MyHomePage(title: 'NEUILLLL'),
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
  final TextEditingController _checkText = TextEditingController();
  LatLng _currentLatLng = LatLng(46.166667, -1.15000048); // Position initiale (La Rochelle)

  // Fonction pour convertir une adresse en coordonnées géographiques
  Future<void> _geocodeLocation(String location) async {
    final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$location&format=json&addressdetails=1&limit=1');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          setState(() {
            _currentLatLng = LatLng(lat, lon);
          });
        } else {
          _showErrorDialog("Aucun résultat trouvé pour cette adresse.");
        }
      } else {
        _showErrorDialog("Erreur lors de la recherche (code ${response.statusCode}).");
      }
    } catch (e) {
      _showErrorDialog("Erreur : ${e.toString()}");
    }
  }

  // Fonction appelée lorsque l'utilisateur clique sur le bouton "Valider"
  void _submitLocation() {
    final location = _checkText.text.trim(); // Retire les espaces inutiles
    if (location.isNotEmpty) {
      _geocodeLocation(location); // Appelle la méthode de géocodage
    } else {
      _showErrorDialog(
          "Veuillez entrer une adresse valide."); // Affiche une alerte si le champ est vide
    }
  }

  // Afficher une boîte de dialogue en cas d'erreur
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                initialCenter: _currentLatLng,
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
