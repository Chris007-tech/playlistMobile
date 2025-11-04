import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService {
  final Dio _dio = Dio();
  Future<String> baixar(
    String nomeArquivo,
    String url, {
    Function(double)? onProgress,
  }) async {
    final dir = await getApplicationDocumentsDirectory();
    final caminho = '${dir.path}/$nomeArquivo.mp3';
    final file = File(caminho);

    if (await file.exists()) return caminho;

    await _dio.download(
      url,
      caminho,
      onReceiveProgress: (recebidos, total) {
        if (total > 0 && onProgress != null) {
          onProgress(recebidos / total);
        }
      },
      options: Options(followRedirects: true),
    );

    return caminho;
  }
}
