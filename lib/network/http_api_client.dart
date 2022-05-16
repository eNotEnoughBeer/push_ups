import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:push_ups/json/task_for_today.dart';
import 'package:push_ups/network/network_client.dart';

Future<Map<String, dynamic>> parseJsonFromAssets(String assetsPath) async {
  return rootBundle
      .loadString(assetsPath)
      .then((jsonStr) => jsonDecode(jsonStr) as Map<String, dynamic>);
}

class HttpApi {
  final _client = NetworkClient();

  Future<TaskForToday> fakeGet(String assetsPath) async {
    final jsonMap = await parseJsonFromAssets(assetsPath);
    final response = TaskForToday.fromJson(jsonMap);
    return response;
  }

  Future<String> simpleGet(String paramValue) async {
    String parser(dynamic json) {
      // тип совпадает с возвратом функции
      final jsonMap = json as Map<String, dynamic>;
      final response = jsonMap['request_token'] as String;
      //final response = ClassName.fromJson(jsonMap);
      return response;
    }

    final urlParams = <String, dynamic>{
      'key': paramValue,
    };

    final result = _client.get(
      'http://example.com/path_to_something',
      parser,
      urlParams,
    );
    return result;
  }

  Future<String> simplePost({
    required String bodyParamValue,
  }) async {
    String parser(dynamic json) {
      // тип совпадает с возвратом функции
      final jsonMap = json as Map<String, dynamic>;
      final response = jsonMap['session_id'] as String;
      //final response = ClassName.fromJson(jsonMap);
      return response;
    }

    final bodyParams = <String, dynamic>{
      'key': bodyParamValue,
    };
    final urlParams = <String, dynamic>{
      'key': 'value',
    };

    final result = _client.post(
      'http://example.com/path_to_something',
      bodyParams,
      parser,
      urlParams,
    );
    return result;
  }
}
