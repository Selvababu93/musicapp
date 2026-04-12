import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repository/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

final AuthRemoteRepository _authRemoteRepository = AuthRemoteRepository();

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AsyncValue<UserModel>? build() {
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final response = await _authRemoteRepository.signup(name: name, email: email, password: password);

    final val = switch (response) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}

// @riverpod
// class AuthViewmodel extends _$AuthViewModel {
//   @override
//   AsyncValue<UserModel>? build() {
//     return null;
//   }

//   Future<void> signUpUser({
//     required String name,
//     required String email,
//     required String password,
//   }) async {
//     final response = await _authRemoteRepository.signup(name: name, email: email, password: password);

//     final val = switch (response) {
//       Left(value: final l) => l,
//       Right(value: final r) => r.name,
//     };
//     print(val);
//   }
// }
