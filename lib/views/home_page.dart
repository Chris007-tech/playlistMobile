import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/playlist_viewmodel.dart';
import '../models/musica.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PlaylistViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Playlist MP3")),
      body: Center(
        child: viewModel.carregando
            ? const CircularProgressIndicator()
            : viewModel.erro != null
            ? Text(
                "Erro: ${viewModel.erro}",
                style: const TextStyle(color: Colors.red),
              )
            : ListView.builder(
                itemCount: viewModel.musicas.length,
                itemBuilder: (context, index) {
                  final Musica musica = viewModel.musicas[index];
                  return ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(musica.titulo),
                    subtitle: Text(musica.autor),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Reproduzindo: ${musica.titulo} "),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.carregarMusicas,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
