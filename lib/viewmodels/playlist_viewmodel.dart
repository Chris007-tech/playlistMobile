import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/musica.dart';
import '../services/api_service.dart';
import '../services/download_service.dart';
import '../services/player_service.dart';

class PlaylistViewModel extends ChangeNotifier {
  final ApiService _api = ApiService();
  final DownloadService _downloadService = DownloadService();
  final ServicoAudio _servicoAudio = ServicoAudio();
  List<Musica> musicas = [];
  bool carregando = false;
  String? erro;
  Musica? musicaAtual;
  StreamSubscription<Duration>? _bufferSub;
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<PlayerState>? _stateSub;
  final Duration _pauseThreshold = const Duration(seconds: 2);
  final Duration _resumeThreshold = const Duration(seconds: 5);

  Future<void> carregarMusicas() async {
    carregando = true;
    erro = null;
    notifyListeners();

    try {
      musicas = await _api.fetchMusicas();
    } catch (e) {
      erro = e.toString();
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> tocar(Musica m) async {
    if (musicaAtual != null &&
        musicaAtual!.url == m.url &&
        _servicoAudio.player.playing) {
      return;
    }
    musicaAtual = m;
    m.estaReproduzindo = true;
    notifyListeners();
    _downloadService
        .baixar(
          _safeFilenameFromTitle(m.titulo),
          m.url,
          onProgress: (p) {
            m.progressoDownload = p;
            notifyListeners();
          },
        )
        .then((caminho) {
          m.caminhoLocal = caminho;
          notifyListeners();
        })
        .catchError((e) {
          debugPrint('Erro no download paralelo: $e');
        });
    await _servicoAudio.tocarUrl(m.url, titulo: m.titulo, autor: m.autor);

    _subscribeBuffering();
  }

  Future<void> pausar() async {
    await _servicoAudio.pausar();
    if (musicaAtual != null) {
      musicaAtual!.estaReproduzindo = false;
      notifyListeners();
    }
  }

  Future<void> parar() async {
    await _servicoAudio.parar();
    if (musicaAtual != null) {
      musicaAtual!.estaReproduzindo = false;
      notifyListeners();
    }
    _cancelSubscriptions();
    musicaAtual = null;
  }

  void _subscribeBuffering() {
    _cancelSubscriptions();

    _bufferSub = _servicoAudio.bufferedPositionStream.listen((buffered) {
      final position = _servicoAudio.player.position;
      final gap = buffered - position;

      if (_servicoAudio.player.playing && gap < _pauseThreshold) {
        _servicoAudio.pausar();
        musicaAtual?.estaReproduzindo = false;
        notifyListeners();
      } else if (!_servicoAudio.player.playing && gap >= _resumeThreshold) {
        _servicoAudio.tocarUrl(
          musicaAtual!.url,
          titulo: musicaAtual!.titulo,
          autor: musicaAtual!.autor,
        );
        musicaAtual?.estaReproduzindo = true;
        notifyListeners();
      }
    });

    _stateSub = _servicoAudio.playerStateStream.listen((state) {
      final playing = state.playing;
      musicaAtual?.estaReproduzindo = playing;
      notifyListeners();
    });
  }

  void _cancelSubscriptions() {
    _bufferSub?.cancel();
    _posSub?.cancel();
    _stateSub?.cancel();
    _bufferSub = null;
    _posSub = null;
    _stateSub = null;
  }

  String _safeFilenameFromTitle(String titulo) {
    final name = titulo.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    return name;
  }

  @override
  void dispose() {
    _cancelSubscriptions();
    _servicoAudio.dispose();
    super.dispose();
  }
}
