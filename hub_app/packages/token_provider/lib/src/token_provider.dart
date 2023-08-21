/// Function contract used by [TokenProvider] to store a token.
typedef StoreToken = Future<void> Function(String token);

/// Function contract used by [TokenProvider] to clear a token.
typedef ClearToken = Future<void> Function();

/// Function contract used by [TokenProvider] load a token from storage.
typedef GetToken = Future<String?> Function();

/// {@template token_provider}
/// Abstraction that stores and provide tokens.
/// {@endtemplate}
class TokenProvider {
  /// {@macro token_provider}
  TokenProvider({
    required StoreToken storeToken,
    required ClearToken clearToken,
    required GetToken getToken,
  })  : _storeToken = storeToken,
        _clearToken = clearToken,
        _getToken = getToken;

  final StoreToken _storeToken;
  final ClearToken _clearToken;
  final GetToken _getToken;

  String? _token;

  /// Sets the token.
  Future<String?> get current async {
    if (_token != null) {
      return Future.value(_token);
    } else {
      return _token = await _getToken();
    }
  }

  /// Sets the token.
  Future<void> applyToken(String token) {
    _token = token;
    return _storeToken(token);
  }

  /// Clears the token.
  Future<void> clear() {
    _token = null;
    return _clearToken();
  }
}
