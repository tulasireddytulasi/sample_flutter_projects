import 'package:dio/dio.dart';

class HttpRequestDio {
  Future<Response> getActorsList({required String url}) async {
    Dio dio = Dio();
    dio.options.baseUrl = 'https://api.themoviedb.org/3/';
    try {
      Response response = await dio.get(url);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
