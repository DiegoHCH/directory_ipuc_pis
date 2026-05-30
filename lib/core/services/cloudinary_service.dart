import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const _cloudName = 'dxxpyj1wg';
const _uploadPreset = 'directory_ipuc_pis';

Future<String> uploadToCloudinary(File imageFile) async {
  final uri = Uri.parse(
    'https://api.cloudinary.com/v1_1/$_cloudName/image/upload',
  );

  final request = http.MultipartRequest('POST', uri)
    ..fields['upload_preset'] = _uploadPreset
    ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

  final streamed = await request.send();
  final body = await streamed.stream.bytesToString();

  if (streamed.statusCode != 200) {
    throw Exception('Cloudinary upload failed (${streamed.statusCode})');
  }

  final json = jsonDecode(body) as Map<String, dynamic>;
  return json['secure_url'] as String;
}

/// Inserta transformaciones en una URL de Cloudinary para obtener un thumbnail.
String cloudinaryThumb(String url, {int size = 200}) => url.replaceFirst(
      '/upload/',
      '/upload/w_$size,h_$size,c_fill,q_auto,f_auto/',
    );
