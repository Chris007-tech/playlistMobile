import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/playlist_viewmodel.dart';
import '../models/musica.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlaylistViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Playlist MP3')),
      body: Center(
        child: vm.carregando
            ? const CircularProgressIndicator()
            : vm.erro != null
            ? Text('Erro: ${vm.erro}')
            : ListView.builder(
                itemCount: vm.musicas.length,
                itemBuilder: (context, index) {
                  final Musica m = vm.musicas[index];
                  final bool estaAtual = vm.musicaAtual?.url == m.url;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.music_note),
                      title: Text(m.titulo),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.autor),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: m.progressoDownload, // 0.0..1.0
                            minHeight: 6,
                            backgroundColor: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            estaAtual
                                ? (m.estaReproduzindo
                                      ? 'Reproduzindo'
                                      : 'Parado / Buffering')
                                : '',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              estaAtual &&
                                      vm.musicaAtual?.estaReproduzindo == true
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            onPressed: () {
                              if (estaAtual &&
                                  vm.musicaAtual?.estaReproduzindo == true) {
                                vm.pausar();
                              } else {
                                vm.tocar(m);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              vm.tocar(m);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: vm.carregarMusicas,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
