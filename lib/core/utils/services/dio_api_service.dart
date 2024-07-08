import 'package:dio/dio.dart';

class DioApiService {
  final Dio dio;

  // declare your baseUrl
  static const String baseUrl = '';

  DioApiService(this.dio);

  //get method.
  Future<Map<String, dynamic>> get({
    required String endPoint,
    String? token,
  }) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll(
        {
          'Authorization': 'Bearer $token',
          //Content-Type , Accept have a value by default..
        },
      );
    }

    Response response = await dio.get(
      '$baseUrl$endPoint',
      options: Options(
        headers: headers,
      ),
    );

    return response.data;
  }

  //post method.
  Future<Map<String, dynamic>> post({
    required String endPoint,
    required dynamic data,
    String? token,
  }) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll(
        {
          'Authorization': 'Bearer $token',
          //Content-Type , Accept have a value by default..
        },
      );
    }

    Response response = await dio.post(
      '$baseUrl$endPoint',
      data: data,
      options: Options(
        headers: headers,
      ),
    );

    return response.data;
  }

  //update methodز
  Future<Map<String, dynamic>> update({
    required String endPoint,
    required dynamic data,
    String? token,
  }) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll(
        {
          'Authorization': 'Bearer $token',
          //Content-Type , Accept have a value by default..
        },
      );
    }

    Response response = await dio.post(
      '$baseUrl$endPoint',
      data: data,
      options: Options(
        headers: headers,
      ),
    );

    return response.data;
  }
}
