import 'dart:io';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<Failure, String>> uploadSong({
    required File selectedAudio,
    required File selectedThumbnail,
    required String songName,
    required String artist,
    required String hexCode,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest("POST", Uri.parse("${ServerConstant.serverUrl}/song/upload"));
      print("Calling Upload");
      request
        ..files.addAll([
          await http.MultipartFile.fromPath("song", selectedAudio.path),
          await http.MultipartFile.fromPath("thumbnail", selectedThumbnail.path),
        ])
        ..fields.addAll({"artist": artist, "song_name": songName, "hex_code": hexCode})
        ..headers.addAll({
          "x-auth-token": token,
        });

      final response = await request.send();
      if (response.statusCode != 201) {
        print("Failure in Song upload:");
        print(Failure(message: await response.stream.bytesToString()));
        return Left(Failure(message: await response.stream.bytesToString()));
      }
      print("Success");
      print(await response.stream.bytesToString());
      return Right(await response.stream.bytesToString());
    } catch (e) {
      print("Error");
      print(e.toString());
      return Left(Failure(message: e.toString()));
    }
  }
}
