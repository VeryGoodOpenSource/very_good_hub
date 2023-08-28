import 'package:db_client/db_client.dart';
import 'package:hub_domain/hub_domain.dart';

/// {@template api_post_repository_adapter}
/// A [PostRepositoryAdapter] that used by the API to manage posts.
/// {@endtemplate}
class APIPostRepositoryAdapter extends PostRepositoryAdapter {
  /// {@macro api_post_repository_adapter}
  APIPostRepositoryAdapter({
    required DbClient dbClient,
  }) : _dbClient = dbClient;

  final DbClient _dbClient;

  static const _tableName = 'posts';

  @override
  Future<Post> createPost({
    required String userId,
    required String message,
  }) async {
    final data = {
      'userId': userId,
      'message': message,
    };
    final id = await _dbClient.add(_tableName, data);

    return Post.fromJson(
      {
        'id': id,
        ...data,
      },
    );
  }

  @override
  Future<Post?> getPost({required String postId}) async {
    final data = await _dbClient.getById(_tableName, postId);

    if (data == null) {
      return null;
    }

    return Post.fromJson(data);
  }
}
