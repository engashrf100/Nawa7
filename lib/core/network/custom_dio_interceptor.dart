import 'package:dio/dio.dart';
import 'package:nawah/core/network/app_links.dart';
import 'package:nawah/core/services/secure_storage_service.dart';
import 'package:nawah/core/services/shared_pref_service.dart';
import 'package:nawah/features/auth/data/model/shared/user_model.dart';

class CustomDioInterceptor extends Interceptor {
  final SecureStorageService storage;
  final SharedPrefService prefs;

  CustomDioInterceptor(this.storage, this.prefs);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isAuthEndpoint =
        options.path.contains(AppLinks.refreshToken) ||
        options.path.contains(AppLinks.logoutUrl) ||
        options.path.contains(AppLinks.profileUpdateUrl);
    final langCode = prefs.getString('locale')?.split('_').first ?? 'en';
    final user = await storage.read('user');
    final token = user != null ? UserModel.fromJson(user).accessToken : null;

    options.headers['Accept-Language'] = langCode;
    options.headers['Cookie'] = 'lang=$langCode';

    if (isAuthEndpoint) {
      options.headers['Authorization'] = 'Bearer $token';
    } else {
      options.headers.remove('Authorization');
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized responses globally
    if (err.response?.statusCode == 401) {
      // Clear user data immediately when we get a 401
      try {
        await storage.delete('user');
        await storage.delete('access_token');
        await storage.delete('refresh_token');
      } catch (e) {
        // Log error but don't fail the request
        print('Error clearing user data on 401: $e');
      }
    }

    handler.next(err);
  }
}
