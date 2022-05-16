import 'dart:convert';
import 'dart:io';
import 'package:push_ups/network/network_client_exception.dart';

class NetworkClient {
  final _client = HttpClient();

  Uri _makeUrl(String path, [Map<String, dynamic>? parameters]) {
    final uri = Uri.parse(path);
    if (parameters != null) {
      return uri.replace(queryParameters: parameters);
    } else {
      return uri;
    }
  }

  Future<T> get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    final url = _makeUrl(path, urlParameters);
    try {
      final request = await _client.getUrl(url);
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw HttpApiException(HttpApiExceptionType.network);
    } on HttpApiException {
      rethrow;
    } catch (e) {
      throw HttpApiException(HttpApiExceptionType.other);
    }
  }

  Future<T> post<T>(
    String path,
    Map<String, dynamic>? bodyParameters,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? urlParameters,
  ]) async {
    final url = _makeUrl(path, urlParameters);
    try {
      final request = await _client.postUrl(url);

      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(bodyParameters));
      final response = await request.close();
      final dynamic json = (await response.jsonDecode());
      _validateResponse(response, json);

      final result = parser(json);
      return result;
    } on SocketException {
      throw HttpApiException(HttpApiExceptionType.network);
    } on HttpApiException {
      rethrow;
    } catch (e) {
      throw HttpApiException(HttpApiExceptionType.other);
    }
  }

  void _validateResponse(HttpClientResponse response, dynamic json) {
    if (response.statusCode == 401) {
      // варианты обработки ошибок
      final dynamic status = json['status_code'];
      final code = status is int ? status : 0;
      if (code == 1) {
        // throw HttpApiException(...);
      }
      if (code == 2) {
        // throw HttpApiException(...);
      }
    }
  }
}

extension HttpClientResponseJsonDecode on HttpClientResponse {
  Future<dynamic> jsonDecode() async {
    return transform(utf8.decoder).toList().then((value) {
      final result = value.join();
      return result;
    }).then<dynamic>((v) => json.decode(v));
  }
}
