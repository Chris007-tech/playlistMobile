import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/playlist_viewmodel.dart';
import 'views/home_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PlaylistViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playlist MP3',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const HomePage(),
    );
  }
}
