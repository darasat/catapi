// cat_api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class CatApiService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1/breeds';
  static const String _apiKey =
      'live_99Qe4Ppj34NdplyLW67xCV7Ds0oSLKGgcWWYnSzMJY9C0QOu0HUR4azYxWkyW2nr';

  // Método que devuelve una lista de razas de gatos o una lista vacía en caso de error
  static Future<List<dynamic>> fetchBreeds() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'x-api-key': _apiKey, // Usamos la clave API adecuada
        },
      );

      // Verificamos si la respuesta es exitosa
      if (response.statusCode == 200) {
        // Convertimos la respuesta en una lista de objetos y la retornamos
        var data = json.decode(response.body);
        if (data is List) {
          return data; // Si la respuesta es una lista, la retornamos
        } else {
          print('La respuesta no es una lista válida');
          return []; // Si no es una lista, devolvemos una lista vacía
        }
      } else {
        // Si la respuesta no es exitosa, mostramos el código de error
        print('Failed to load cat breeds: ${response.statusCode}');
        return []; // Devolvemos una lista vacía en caso de error
      }
    } catch (e) {
      // Si ocurre un error, lo capturamos y lo mostramos
      print('Error: $e');
      return []; // Devolvemos una lista vacía en caso de excepción
    }
  }
}
