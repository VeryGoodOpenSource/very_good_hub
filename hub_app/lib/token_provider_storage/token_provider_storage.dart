import 'package:shared_preferences/shared_preferences.dart';

class TokenProviderStorage {
  static const _tokenKey = 'token';

  // This implementation uses SharedPreferences to store the token
  // to offer a simple example.
  //
  // Ideally a more secure storage should be used instead.

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
