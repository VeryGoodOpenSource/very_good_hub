import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:db_client/db_client.dart';

late final DbClient dbClient;

Future<void> init(InternetAddress ip, int port) async {
  dbClient = DbClient();
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  return serve(
    handler.use(provider<DbClient>((_) => dbClient)),
    ip,
    port,
  );
}
