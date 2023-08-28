import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:hub_domain/hub_domain.dart';
import 'package:very_good_hub_api/models/models.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.post => _onPost(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final apiSession = context.read<ApiSession>();
  final postRepository = context.read<PostRepository>();

  final body = await context.request.json() as Map<String, dynamic>;

  final postMessage = body['message'] as String?;

  if (postMessage == null) {
    return Response(statusCode: HttpStatus.badRequest);
  } else {
    try {
      final post = await postRepository.createPost(
        userId: apiSession.user.id,
        message: postMessage,
      );

      return Response.json(
        statusCode: HttpStatus.created,
        body: post.toJson(),
      );
    } on PostCreationFailure catch (e) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': e.reason.name},
      );
    } catch (e) {
      return Response.json(
        statusCode: HttpStatus.internalServerError,
        body: {'error': 'unknown'},
      );
    }
  }
}
