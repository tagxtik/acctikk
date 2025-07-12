import 'dart:html' as html;
import 'dart:typed_data';

Future<List<Uint8List>> pickImages() async {
  List<Uint8List> images = [];
  final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.multiple = true;
  uploadInput.click();

  uploadInput.onChange.listen((e) async {
    final files = uploadInput.files;
    if (files != null) {
      for (var file in files) {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        await reader.onLoad.first;
        images.add(reader.result as Uint8List);
      }
    }
  });
  return images;
}