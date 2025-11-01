import 'package:flutter/material.dart';
import '../models/musica.dart';
import '../services/api_service.dart';

class PlaylistViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Musica> musicas = [];
  bool carregando = false;
  String? erro;

  Future<void> carregarMusicas() async {
    try {
      carregando = true;
      erro = null;
      notifyListeners();

      musicas = await _apiService.fetchMusicas();
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
