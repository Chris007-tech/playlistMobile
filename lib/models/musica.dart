class Musica {
  final String titulo;
  final String autor;
  final String url;
  final String duracao;
  double progressoDownload;
  bool estaBaixando;
  bool estaReproduzindo;

  Musica({
    required this.titulo,
    required this.autor,
    required this.url,
    required this.duracao,
    this.progressoDownload = 0.0,
    this.estaBaixando = false,
    this.estaReproduzindo = false,
  });

  factory Musica.fromJson(Map<String, dynamic> json) {
    return Musica(
      titulo: json['title'] ?? '',
      autor: json['author'] ?? '',
      url: json['url'] ?? '',
      duracao: json['duration'] ?? '',
    );
  }
}
