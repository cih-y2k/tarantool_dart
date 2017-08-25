import 'dart:async';

import 'connection.dart';
import 'iterator.dart';
import 'message.dart';

class TarantoolClient {
  TarantoolClient(String host, int port)
      : this.withConnection(new TarantoolConnection(host, port));

  TarantoolClient.withConnection(this._connection);

  final TarantoolConnection _connection;

  int _syncId = 0;

  int _getSync() => _syncId++;

  Future<String> connect() async => _connection.connect();

  Future<List<dynamic>> select(int spaceId, int indexId, int limit, int offset,
      TarantoolIterator iterator, List<int> key) async {
    final message = TarantoolMessage.select(
        spaceId: spaceId,
        indexId: indexId,
        limit: limit,
        offset: offset,
        iterator: iterator,
        key: key,
        sync: _getSync());
    return _connection.send(message);
  }

  Future<List<dynamic>> insert(int spaceId, List tuple) async {
    var message = TarantoolMessage.insert(
        spaceId: spaceId, tuple: tuple, sync: _getSync());
    return _connection.send(message);
  }
}
