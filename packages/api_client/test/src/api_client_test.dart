// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:token_provider/token_provider.dart';

class _MockResponse extends Mock implements Response {}

abstract class _HttpClient {
  Future<Response> get(Uri url, {Map<String, String>? headers});
  Future<Response> post(Uri url, {Object? body, Map<String, String>? headers});
}

class _MockHttpClient extends Mock implements _HttpClient {}

class _MockTokenProvider extends Mock implements TokenProvider {}

void main() {
  group('ApiClient', () {
    late _HttpClient httpClient;
    late ApiClient apiClient;
    late TokenProvider tokenProvider;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = _MockHttpClient();
      tokenProvider = _MockTokenProvider();
      apiClient = ApiClient(
        baseUrl: 'https://example.com',
        get: httpClient.get,
        post: httpClient.post,
        tokenProvider: tokenProvider,
      );
    });

    test('can be instantiated', () {
      expect(
        ApiClient(
          baseUrl: 'https://example.com',
          tokenProvider: _MockTokenProvider(),
        ),
        isNotNull,
      );
    });

    test('can do a get request', () async {
      final response = _MockResponse();
      when(() => httpClient.get(any())).thenAnswer((_) async => response);

      final result = await apiClient.get('path');

      expect(result, equals(response));
      verify(() => httpClient.get(Uri.parse('https://example.com/path')));
    });

    test('can do a post request', () async {
      final response = _MockResponse();
      when(
        () => httpClient.post(
          any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'),
        ),
      ).thenAnswer((_) async => response);

      final result = await apiClient.post(
        'path',
        body: 'body',
        headers: {
          'header': 'value',
        },
      );

      expect(result, equals(response));
      verify(
        () => httpClient.post(
          Uri.parse('https://example.com/path'),
          body: 'body',
          headers: {
            'header': 'value',
          },
        ),
      );
    });

    group('authenticated requests', () {
      test('can do a get request', () async {
        final response = _MockResponse();
        when(
          () => httpClient.get(
            any(),
            headers: any(
              named: 'headers',
            ),
          ),
        ).thenAnswer((_) async => response);
        when(() => tokenProvider.current).thenAnswer((_) async => 'token');

        final result = await apiClient.authenticatedGet('path');

        expect(result, equals(response));
        verify(
          () => httpClient.get(
            Uri.parse('https://example.com/path'),
            headers: {
              'Authorization': 'Bearer token',
            },
          ),
        );
      });

      test('returns unauthorized when there is no token', () async {
        final response = _MockResponse();
        when(
          () => httpClient.get(
            any(),
            headers: any(
              named: 'headers',
            ),
          ),
        ).thenAnswer((_) async => response);
        when(() => tokenProvider.current).thenAnswer((_) async => null);

        final result = await apiClient.authenticatedGet('path');

        expect(result.statusCode, equals(HttpStatus.unauthorized));
      });
    });
  });
}
