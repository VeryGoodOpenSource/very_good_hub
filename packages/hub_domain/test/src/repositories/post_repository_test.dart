import 'package:bad_words/bad_words.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockPostRepositoryAdapter extends Mock
    implements PostRepositoryAdapter {}

class _MockFilter extends Mock implements Filter {}

void main() {
  group('can be instantiated', () {
    late Filter filter;
    late PostRepositoryAdapter adapter;
    late PostRepository repository;

    const post = Post(
      id: '',
      userId: '',
      message: '',
    );

    setUp(() {
      filter = _MockFilter();
      adapter = _MockPostRepositoryAdapter();

      repository = PostRepository(
        adapter: adapter,
        profanityFilter: filter,
      );
    });

    test('can be instantiated', () {
      expect(
        PostRepository(
          adapter: _MockPostRepositoryAdapter(),
        ),
        isA<PostRepository>(),
      );
    });

    group('createPost', () {
      test('returns the created post', () async {
        when(() => filter.isProfane(any())).thenReturn(false);

        when(
          () => adapter.createPost(
            userId: any(named: 'userId'),
            message: any(named: 'message'),
          ),
        ).thenAnswer((_) async => post);

        final result = await repository.createPost(
          userId: '',
          message: '',
        );

        expect(result, equals(post));
      });

      test(
        'throws PostCreationFailure with too long error when the message is '
        'too long',
        () {
          when(() => filter.isProfane(any())).thenReturn(false);

          expect(
            () => repository.createPost(
              userId: '',
              message: 'a' * 1001,
            ),
            throwsA(
              isA<PostCreationFailure>().having(
                (e) => e.reason,
                'reason',
                equals(CreatePostFailure.tooLong),
              ),
            ),
          );
        },
      );

      test(
        'throws PostCreationFailure with is profane error when the message is '
        'profane',
        () {
          when(() => filter.isProfane(any())).thenReturn(true);

          expect(
            () => repository.createPost(
              userId: '',
              message: '',
            ),
            throwsA(
              isA<PostCreationFailure>().having(
                (e) => e.reason,
                'reason',
                equals(CreatePostFailure.isProfane),
              ),
            ),
          );
        },
      );

      test(
        'throws PostCreationFailure with unexpected error an unknown error '
        'happens',
        () {
          when(() => filter.isProfane(any())).thenReturn(false);

          when(
            () => adapter.createPost(
              userId: any(named: 'userId'),
              message: any(named: 'message'),
            ),
          ).thenThrow(Exception());

          expect(
            () => repository.createPost(
              userId: '',
              message: '',
            ),
            throwsA(
              isA<PostCreationFailure>().having(
                (e) => e.reason,
                'reason',
                equals(CreatePostFailure.unexpected),
              ),
            ),
          );
        },
      );
    });

    group('getPost', () {
      test('returns the post', () async {
        when(
          () => adapter.getPost(
            postId: any(named: 'postId'),
          ),
        ).thenAnswer((_) async => post);

        final result = await repository.getPost(
          postId: '',
        );

        expect(result, equals(post));
      });
    });
  });
}
