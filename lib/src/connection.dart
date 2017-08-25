import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:msgpack/msgpack.dart';

import 'constants.dart';
import 'error.dart';
import 'message.dart';
import 'response.dart';

class TarantoolConnection {
  TarantoolConnection(this.host, this.port);

  final String host;
  final int port;

  Socket _socket;
  final _streamController = new StreamController<Response>.broadcast();

  Future<String> connect() async {
    print("host = $host, port = $port");
    _socket = await Socket.connect(host, port);
    final stream = _socket.asBroadcastStream();

    stream.skip(1).listen(_handler);
    final greetingData = await stream.first;
    final greeting = new String.fromCharCodes(greetingData);
    final serverInfo = greeting.split("\n")[0];
    final authInfo = greeting.split("\n")[1];
    final encoded_salt = authInfo.substring(0, 44).trimRight();
    // ignore: unused_local_variable
    final salt = BASE64.decode(encoded_salt);

    return serverInfo;
  }

  void _handler(List<int> data) {
    final list = new Uint8List.fromList(data);
    final unpacker = new Unpacker(list.buffer);

    var unpackedLength = 0;
    while (unpackedLength != list.length) {
      var message = unpacker.unpackList(3);
      unpackedLength += message[0] + 5;
      final header = message[1];
      final body = message[2];

      var response;
      if (header[UserKey.code] == 0) {
        response = new Response(
            sync: header[UserKey.sync], payload: body[UserKey.data]);
        _streamController.add(response);
      } else {
        response = new Response(
          sync: header[UserKey.sync],
          error: body[UserKey.error],
          errorCode: header[UserKey.code],
        );
      }

      _streamController.add(response);
    }
  }

  Future<List<dynamic>> send(TarantoolMessage message) async {
    if (_socket == null) {
      throw new StateError("Socket is null. Connect before any operations");
    }

    _socket.add(message.length);
    _socket.add(message.header);
    _socket.add(message.body);

    final Response response =
        await _streamController.stream.firstWhere(_isForA(message));

    if (response.isSuccess()) {
      return response.payload;
    } else {
      throw TarantoolError.fromResponse(response);
    }
  }
}

_isForA(TarantoolMessage m) => (Response r) => r.sync == m.sync;
