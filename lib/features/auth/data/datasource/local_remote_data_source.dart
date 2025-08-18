import 'package:nawah/core/services/secure_storage_service.dart';
import 'package:nawah/features/auth/data/model/shared/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getSavedUser();
  Future<void> deleteSavedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService secureStorageService;
  static const String userKey = 'user';

  AuthLocalDataSourceImpl(this.secureStorageService);

  @override
  Future<void> saveUser(UserModel user) async {
    await secureStorageService.write(userKey, user.toJson());
  }

  @override
  Future<UserModel?> getSavedUser() async {
    final json = await secureStorageService.read(userKey);
    if (json == null) return null;
    return UserModel.fromJson(json);
  }

  @override
  Future<void> deleteSavedUser() async {
    await secureStorageService.delete(userKey);
  }
}
