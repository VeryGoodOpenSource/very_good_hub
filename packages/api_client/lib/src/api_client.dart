import 'package:http/http.dart' as http;

/// {@template api_client}
/// Client to access the APIs of Very Good Hub.
/// {@endtemplate}
class ApiClient {
  /// {@macro api_client}
  const ApiClient({
    required String baseUrl,
    Future<http.Response> Function(Uri uri) get = http.get,
    Future<http.Response> Function(Uri uri, {Object? body}) post = http.post,
  })  : _baseUrl = baseUrl,
        _get = get,
        _post = post;

  final String _baseUrl;

  final Future<http.Response> Function(Uri uri) _get;
  final Future<http.Response> Function(Uri uri, {Object? body}) _post;

  /// Does a get request.
  Future<http.Response> get(String path) async {
    final url = Uri.parse('$_baseUrl/$path');
    return _get(url);
  }

  /// Does a post request.
  Future<http.Response> post(String path, {Object? body}) async {
    final url = Uri.parse('$_baseUrl/$path');

    return _post(url, body: body);
  }
}
