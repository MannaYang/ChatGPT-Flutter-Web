import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:frontend/pages/auth/provider/auth_provider.dart';
import 'package:frontend/service/utils/sp_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_provider.g.dart';

///
/// ```dart
///   ref.read(httpRequestProvider).get()
/// ```
/// - [post] -> http
/// - [get] -> http
/// - [multipartFile] -> http
/// - [multipartFileUrl] -> http
///
@Riverpod(keepAlive: true)
class HttpRequest extends _$HttpRequest {
  @override
  void build() {}

  String get _latestToken => SpProvider().getString('token');

  Duration _timeout(int seconds) => Duration(seconds: seconds);

  static const int _reqTime = 45;
  static const int _fileTime = 120;

  Map<String, String> _tokenHeader() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': _latestToken,
    };
  }

  Future<Response> _handleResponse(Future<Response> response) async {
    try {
      var data = await response;
      Logger().d("HttpProvider - Response = ${data.body}");
      if (data.statusCode == 401) {
        await SpProvider().setString("token", "");
        await SpProvider().setString("userId", "");
        ref.read(tokenExpiredProvider.notifier).build();
        throw Exception(data.reasonPhrase ?? "Token has been expired");
      }
      return data;
    } catch (e) {
      Logger().d("HttpProvider - Exception =  ${e.toString()}");
      rethrow;
    }
  }

  Future<StreamedResponse> _handleStreamResponse(
      Future<StreamedResponse> response) async {
    try {
      var data = await response;
      Logger().d("");
      Logger().d(
          "HttpProvider - Headers = ${data.request?.headers} \n HttpProvider - Request = ${data.request?.url.toString()}");
      if (data.statusCode == 401) {
        await SpProvider().setString("token", "");
        ref.read(tokenExpiredProvider.notifier).build();
        throw Exception(data.reasonPhrase ?? "Token has been expired");
      }
      return data;
    } catch (e) {
      Logger().d("HttpProvider - Exception =  ${e.toString()}");
      rethrow;
    }
  }

  ///
  /// http - post
  ///
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    dynamic body,
    int timeout = _reqTime,
  }) async {
    var bodyData = body == null ? body : jsonEncode(body);
    Logger().d(
        "HttpProvider - Request = $url \nHttpProvider - Request = $bodyData");
    var response = http
        .post(url, headers: _tokenHeader(), body: bodyData)
        .timeout(_timeout(timeout));
    return _handleResponse(response);
  }

  ///
  /// http - get
  ///
  Future<Response> get(
    Uri url, {
    Map<String, String>? headers,
    int timeout = _reqTime,
  }) {
    Logger().d("HttpProvider - Request = $url");
    var response =
        http.get(url, headers: _tokenHeader()).timeout(_timeout(timeout));
    return _handleResponse(response);
  }

  ///
  /// http - multipartFile
  ///
  Future<http.StreamedResponse> multipartFile(
    Uri url,
    String fileName,
    Uint8List? bytes, {
    int timeout = _fileTime,
  }) {
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({'Authorization': _latestToken})
      ..files.add(http.MultipartFile.fromBytes('files', bytes as List<int>,
          filename: fileName));
    var response = request.send().timeout(_timeout(timeout));
    return _handleStreamResponse(response);
  }

  ///
  /// http - multipartFile bytes
  ///
  Future<http.StreamedResponse> multipartFileUrl(
    Uri url,
    String fileName,
    Uint8List? bytes, {
    int timeout = _fileTime,
  }) async {
    var file = http.MultipartFile.fromBytes('files', bytes as List<int>,
        filename: fileName);
    var request = http.MultipartRequest('POST', url)
      ..headers.addAll({'Authorization': _latestToken})
      ..files.add(file);
    var response = request.send().timeout(_timeout(timeout));
    return _handleStreamResponse(response);
  }
}
