import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

// it will handle automatically dispose, caching and all
@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<Failure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("${ServerConstant.serverUrl}/auth/signup");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200 && response.statusCode != 201) {
        return Left(Failure(message: data['detail']));
      }
      return Right(UserModel.fromMap(data));
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> login({required String email, required String password}) async {
    try {
      final url = Uri.parse("${ServerConstant.serverUrl}/auth/login");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      // print("Status: ${response.statusCode}");
      // print("Response body: ${response.body}");

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      print(data);
      if (response.statusCode != 200 && response.statusCode != 201) {
        return Left(Failure(message: data['detail']));
      }

      return Right(UserModel.fromMap(data['user']).copyWith(token: data['token']));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  Future<Either<Failure, UserModel>> getCurrentUserData(String token) async {
    try {
      final url = Uri.parse('${ServerConstant.serverUrl}/auth/');
      final response = await http.get(url, headers: {"Content-Type": "application/json", "x-auth-token": token});
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print(data);
      if (response.statusCode != 200) {
        Left(Failure(message: data['detail']));
      }

      return Right(UserModel.fromMap(data).copyWith(token: token));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
