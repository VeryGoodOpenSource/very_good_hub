import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final dbClient = DbClient();
  return serve(
    handler.use(provider<DbClient>((_) => dbClient)),
    ip,
    port,
  );
}
