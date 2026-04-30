import 'package:dio/dio.dart';

import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
      : dio = Dio(BaseOptions(
    baseUrl: "https://www.themealdb.com/api/json/v1/1/",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<Response> get(String path, {Map<String, dynamic>? params}) async {
    return await dio.get(path, queryParameters: params);
  }
}