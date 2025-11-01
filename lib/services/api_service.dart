import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/musica.dart';

class ApiService {
  static const String _url =
      'https://www.rafaelamorim.com.br/mobile2/musicas/list.json';

  Future<List<Musica>> fetchMusicas() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final List<dynamic> dados = json.decode(response.body);
        return dados.map((item) => Musica.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao carregar músicas (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Erro ao buscar playlist: $e');
    }
  }
}
