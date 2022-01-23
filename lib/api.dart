import 'dart:io';

import 'package:http/http.dart' as http;

class MyApi {
  MyApi();

  Future<void> sendFile(File file, String badgeId) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://51.250.20.15:3030/asrupload'),
    );

    final len = file.lengthSync();

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        file.readAsBytesSync(),
        filename: 'file.mp3',
      ),
    );
    request.fields.addAll({
      'badge_id': badgeId,
      'time': DateTime.now().millisecondsSinceEpoch.toString(),
    });

    final res = await request.send();
    final respStr = await res.stream.bytesToString();
    print(res);
  }
}
