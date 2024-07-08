import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class HttpApiService {
  Future<dynamic> get({required String url, String? token}) async {
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll(
        {
          'Authorization': 'Bearer $token',
          //Content-Type , Accept have a value by default..
        },
      );
    }
    http.Response response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'there is a problem whith a status code = ${response.statusCode}');
    }
  }

  Future<dynamic> post({
    required String url,
    required dynamic body,
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
    http.Response response = await http.post(
      Uri.parse(url),
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
        'there is a problem whith a status code = ${response.statusCode},with body ${jsonDecode(response.body)}',
      );
    }
  }

  Future<dynamic> ubdate(
      {required String url, required dynamic body, String? token}) async {
    log('url = $url  body = $body token = $token');
    Map<String, String> headers = {};
    if (token != null) {
      headers.addAll(
        {
          'Authorization': 'Bearer $token',
          //Content-Type , Accept have a value by default..
        },
      );
    }

    http.Response response = await http.put(
      Uri.parse(url),
      body: body,
      headers: headers,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      return data;
    } else {
      throw Exception(
        'there is a problem whith a status code = ${response.statusCode},with body ${jsonDecode(response.body)}',
      );
    }
  }
}
