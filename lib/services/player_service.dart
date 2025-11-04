import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class ServicoAudio {
  final AudioPlayer _player = AudioPlayer();

  ServicoAudio();

  Future<void> dispose() async {
    await _player.dispose();
  }

  Future<void> tocarUrl(String url, {String? titulo, String? autor}) async {
    final mediaItem = MediaItem(
      id: url,
      album: '',
      title: titulo ?? 'Sem título',
      artist: autor ?? '',
    );
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(url), tag: mediaItem),
    );
    await _player.play();
  }

  Future<void> pausar() => _player.pause();

  Future<void> parar() => _player.stop();

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<ProcessingState> get processingStateStream =>
      _player.processingStateStream;

  AudioPlayer get player => _player;
}
