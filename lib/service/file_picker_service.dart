// file_picker_service.dart
import 'dart:html' as html;
import 'dart:async';

Future<html.File> pickFile() async {
  final completer = Completer<html.File>();
  final input = html.FileUploadInputElement();
  input.accept =
      'image/*'; // Especifique o tipo de arquivo que você deseja aceitar
  input.click();

  input.onChange.listen((e) {
    final file = input.files?.first;
    if (file != null) {
      completer.complete(file);
    } else {
      completer.completeError('Nenhum arquivo selecionado');
    }
  });

  return completer.future;
}
