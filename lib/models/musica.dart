class Musica {
  final String titulo;
  final String autor;
  final String url;
  final String duracao;

  bool estaReproduzindo;
  double progressoDownload;
  String? caminhoLocal;

  Musica({
    required this.titulo,
    required this.autor,
    required this.url,
    required this.duracao,
    this.estaReproduzindo = false,
    this.progressoDownload = 0.0,
    this.caminhoLocal,
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
