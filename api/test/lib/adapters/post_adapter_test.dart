import 'package:db_client/db_client.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:very_good_hub_api/adapters/adapters.dart';

class _MockDbClient extends Mock implements DbClient {}

void main() {
  group('APIPostRepositoryAdapter', () {
    late DbClient dbClient;
    late APIPostRepositoryAdapter adapter;

    setUp(() {
      dbClient = _MockDbClient();
      adapter = APIPostRepositoryAdapter(dbClient: dbClient);
    });

    test('can be instantiated', () {
      expect(APIPostRepositoryAdapter(dbClient: _MockDbClient()), isNotNull);
    });

    test('createPost correctly inserts in the db', () async {
      const userId = 'userId';
      const message = 'message';
      const id = 'id';

      final data = {
        'userId': userId,
        'message': message,
      };
      final post = Post.fromJson({
        'id': id,
        ...data,
      });

      when(() => dbClient.add(any(), any())).thenAnswer((_) async => id);

      final result = await adapter.createPost(userId: userId, message: message);

      expect(result, equals(post));
      verify(() => dbClient.add('posts', data)).called(1);
    });

    test('getPost correctly retrieves from the db', () async {
      const userId = 'userId';
      const message = 'message';
      const id = 'id';

      final data = {
        'id': id,
        'userId': userId,
        'message': message,
      };
      final post = Post.fromJson(data);

      when(() => dbClient.getById(any(), any())).thenAnswer((_) async => data);

      final result = await adapter.getPost(postId: id);

      expect(result, equals(post));
      verify(() => dbClient.getById('posts', id)).called(1);
    });

    test('listHomePosts returns the last 10 posts', () async {
      final posts = List.generate(10, (i) {
        return Post(
          id: i.toString(),
          userId: 'userId',
          message: 'message',
        );
      });

      when(() => dbClient.find(any(), any())).thenAnswer(
        (_) async => posts.map((e) => e.toJson()).toList(),
      );

      final result = await adapter.listHomePosts();

      expect(result, hasLength(10));
      expect(result, equals(posts));
      verify(() => dbClient.find('posts', any())).called(1);
    });
  });
}
