import 'package:dio/dio.dart';
import 'package:mobile_data_collection/service/storage_service.dart';
import 'package:mobile_data_collection/service/navigation_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio dio;

  factory DioClient() {
    return _instance;
  }
  DioClient._internal() {    dio = Dio(BaseOptions(
      baseUrl: '',
      headers: {
        'Content-Type': 'application/json',
        // 'Accept': 'application/json',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(      onRequest: (options, handler) async {
        print("Envoi requête à : ${options.uri}");
        print("Headers : ${options.headers}");
        print("Data : ${options.data}");
        
        final token = await StorageService.readData('jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },      onError: (e, handler) async {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          // Token expiré, invalide ou droits insuffisants
          await StorageService.deleteData('jwt_token'); // On supprime le token
          NavigationService.redirectToLogin(); // On redirige
        } else if (e.type == DioExceptionType.unknown) {
          // Erreur inconnue (problème de connexion, etc.)
          print("Erreur de connexion: ${e.message}");
        }
        return handler.next(e);
      },
    ));
  }
}
