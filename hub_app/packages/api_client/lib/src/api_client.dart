import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:token_provider/token_provider.dart';

/// {@template api_client}
/// Client to access the APIs of Very Good Hub.
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  const ApiClient({
    required String baseUrl,
    required TokenProvider tokenProvider,
    Future<http.Response> Function(
      Uri uri, {
      Map<String, String>? headers,
    }) get = http.get,
    Future<http.Response> Function(
      Uri uri, {
      Object? body,
      Map<String, String>? headers,
    }) post = http.post,
  })  : _baseUrl = baseUrl,
        _tokenProvider = tokenProvider,
        _get = get,
        _post = post;

  final String _baseUrl;
  final TokenProvider _tokenProvider;

  final Future<http.Response> Function(
    Uri uri, {
    Map<String, String>? headers,
  }) _get;
  final Future<http.Response> Function(
    Uri uri, {
    Object? body,
    Map<String, String>? headers,
  }) _post;

  /// Does a get request.
  Future<http.Response> get(String path) async {
    final url = Uri.parse('$_baseUrl/$path');
    return _get(url);
  }

  /// Does an authenticated get request.
  Future<http.Response> authenticatedGet(String path) async {
    final token = await _tokenProvider.current;

    if (token == null) {
      return Response('', HttpStatus.unauthorized);
    }

    final url = Uri.parse('$_baseUrl/$path');
    return _get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }

  /// Does a post request.
  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('$_baseUrl/$path');

    return _post(url, body: body, headers: headers);
  }

  /// Does an authenticated post request.
  Future<http.Response> authenticatedPost(
    String path, {
    Object? body,
    Map<String, String>? headers,
  }) async {
    final token = await _tokenProvider.current;

    if (token == null) {
      return Response('', HttpStatus.unauthorized);
    }

    final url = Uri.parse('$_baseUrl/$path');

    return _post(
      url,
      body: body,
      headers: {
        ...?headers,
        'Authorization': 'Bearer $token',
      },
    );
  }
}
