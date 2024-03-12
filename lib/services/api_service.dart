import 'dart:convert';

import 'package:http/http.dart' as http;

// A simplified Result class for demonstration.
class Result<T> {
  final T? data;
  final String? error;

  Result.success(this.data) : error = null;
  Result.failure(this.error) : data = null;

  bool get isSuccess => data != null;
  bool get isFailure => error != null;
}

class ApiService {
  final String _baseUrl = "https://nodejs-healthcare-api-server.onrender.com";

  Future<Result<dynamic>> getRequest(String endpoint) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$endpoint'));
      if (response.statusCode == 200) {
        return Result.success(jsonDecode(response.body));
      }
      return Result.failure('Failed to load data from $endpoint');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<dynamic>> postRequest(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 201) {
        return Result.success(jsonDecode(response.body));
      }
      return Result.failure('Failed to post data to $endpoint');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<dynamic>> putRequest(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return Result.success(jsonDecode(response.body));
      }
      return Result.failure('Failed to update data on $endpoint');
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
