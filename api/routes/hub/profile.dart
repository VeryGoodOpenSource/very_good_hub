import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:hub_domain/hub_domain.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => Future.value(Response(statusCode: HttpStatus.methodNotAllowed)),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final user = context.read<User>();
  return Response.json(body: user.toJson());
}
