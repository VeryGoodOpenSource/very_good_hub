// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:token_provider/token_provider.dart';

void main() {
  group('TokenProvider', () {
    test('can be instantiated', () {
      expect(
        TokenProvider(
          storeToken: (_) async {},
          clearToken: () async {},
          getToken: () async => '',
        ),
        isNotNull,
      );
    });

    test('stores a token', () async {
      var token = '';
      final tokenProvider = TokenProvider(
        storeToken: (t) async => token = t,
        clearToken: () async {},
        getToken: () async => '',
      );

      await tokenProvider.applyToken('token');

      expect(token, equals('token'));
    });

    test('clears a token', () async {
      String? token = '';
      final tokenProvider = TokenProvider(
        storeToken: (t) async => token = t,
        clearToken: () async => token = null,
        getToken: () async => token,
      );

      await tokenProvider.applyToken('token');
      await tokenProvider.clear();

      expect(token, isNull);
    });

    test('returns the stored token when none in memory', () async {
      final tokenProvider = TokenProvider(
        storeToken: (_) async {},
        clearToken: () async {},
        getToken: () async => 'token',
      );

      final token = await tokenProvider.current;

      expect(token, equals('token'));
    });

    test('returns the memory token when one exists', () async {
      final tokenProvider = TokenProvider(
        storeToken: (_) async {},
        clearToken: () async {},
        getToken: () async => 'token',
      );

      await tokenProvider.current;
      final token = await tokenProvider.current;

      expect(token, equals('token'));
    });
  });
}
