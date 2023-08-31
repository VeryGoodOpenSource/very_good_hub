import 'dart:convert';
import 'dart:io';

import 'package:api_client/api_client.dart';
import 'package:hub_domain/hub_domain.dart';

/// {@template hub_post_repository_adapter}
/// Implementation of [PostRepository] that uses the Hub API.
/// {@endtemplate}
class HubPostRepositoryAdapter extends PostRepositoryAdapter {
  /// {@macro hub_post_repository_adapter}
  HubPostRepositoryAdapter({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<Post> createPost({
    required String userId,
    required String message,
  }) async {
    final response = await _apiClient.authenticatedPost(
      'hub/posts',
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userId': userId,
        'message': message,
      }),
    );

    if (response.statusCode != HttpStatus.created) {
      throw HttpException(
        'Invalid response code: ${response.statusCode}',
        uri: response.request?.url,
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return Post.fromJson(json);
  }

  @override
  Future<Post?> getPost({required String postId}) {
    throw UnimplementedError();
  }
}
