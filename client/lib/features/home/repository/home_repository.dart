import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:http/http.dart' as http;

class HomeRepository {
  Future<void> uploadSong({required File selectedAudio, required File selectedImage}) async {
    try {
      final request = http.MultipartRequest("POST", Uri.parse("${ServerConstant.serverUrl}/song/upload"));
      print("Calling Upload");
      request
        ..files.addAll([
          await http.MultipartFile.fromPath("song", selectedAudio.path),
          await http.MultipartFile.fromPath("thumbnail", selectedImage.path),
        ])
        ..fields.addAll({"artist": "eminem", "song_name": "from emulator", "hex_code": "FFFFFF"})
        ..headers.addAll({
          "x-auth-token":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVmYjRlNWUzLTE3MTEtNDU5Yy04OWNiLWEzZDRhODkyYWIxZiJ9.yBW9WL-ykrMnGSvzB-VoA53JxiJKHZkWwM43OURa6Qk",
        });

      final response = await request.send();
      print("Response Upload : $response");
    } catch (e) {
      print("Error: $e");
    }
  }
}
