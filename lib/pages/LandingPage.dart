import 'package:flutter/material.dart';
import '../services/ApiService.dart';
import 'dart:async';
import '../pages/DetailPage.dart'; // Asegúrate de importar la página de detalle
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Future<List<dynamic>> _breeds;
  TextEditingController searchController = TextEditingController();
  List<dynamic> breeds = []; // Lista completa de razas
  List<dynamic> filteredBreeds = []; // Lista de razas filtradas

  @override
  void initState() {
    super.initState();
    _breeds = CatApiService.fetchBreeds();
    _breeds.then((breedsData) {
      setState(() {
        breeds = breedsData; // Guardamos las razas al cargar los datos
        filteredBreeds = breeds; // Inicializamos las razas filtradas
      });
    }).catchError((error) {
      print('Error fetching breeds: $error');
    });
  }

  // Función para navegar a la página de detalles
  void _navigateToDetailPage(Map<String, dynamic> breed) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(breed: breed),
      ),
    );
  }

  // Función para filtrar las razas
  void _filterBreeds(String query) {
    String queryLowerCase = query.trim().toLowerCase();

    setState(() {
      if (queryLowerCase.isEmpty) {
        filteredBreeds =
            breeds; // Si la consulta está vacía, mostramos todas las razas
      } else {
        filteredBreeds = breeds.where((breed) {
          var breedName = breed['name']?.toLowerCase() ??
              ''; // Convertimos el nombre de la raza a minúsculas
          return breedName.contains(
              queryLowerCase); // Comparamos si el nombre contiene la búsqueda
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Breeds'),
      ),
      body: Column(
        children: [
          // Campo de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search for a breed...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (String text) {
                _filterBreeds(text); // Filtra las razas cuando el texto cambia
              },
            ),
          ),

          // Lista de razas
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _breeds,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: filteredBreeds.length,
                    itemBuilder: (context, index) {
                      final breed = filteredBreeds[index];
                      return GestureDetector(
                        onTap: () {
                          _navigateToDetailPage(breed);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header de la tarjeta con el nombre y los tres puntos
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      breed['name'] ?? 'Unknown breed',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () {
                                        // Lógica para mostrar más información o opciones
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              // Imagen de la raza
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  breed['image'] != null
                                      ? breed['image']['url'] ?? ''
                                      : '',
                                  height: 200,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              // Información adicional
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      breed['origin'] ?? 'Unknown origin',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                    Text(
                                      breed['intelligence'] != null
                                          ? 'Intelligence: ${breed['intelligence']}'
                                          : 'Intelligence: Unknown',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: Text('No data available.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
