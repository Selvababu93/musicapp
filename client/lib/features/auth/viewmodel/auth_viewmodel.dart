import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repository/auth_remote_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

// creating class to generate code using riverpod generator
@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRemoteRepository _authRemoteRepository;
  // asyncvalue will give us three values data,loading, error
  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    return null;
  }

  // definig function
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

  Future<void> loginUser({required String email, required String password}) async {
    state = const AsyncValue.loading();
    final response = await _authRemoteRepository.login(email: email, password: password);

    final val = switch (response) {
      Left(value: final l) => state = AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}
