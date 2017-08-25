import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:msgpack/msgpack.dart';

import 'constants.dart';
import 'iterator.dart';

class TarantoolMessage {
  TarantoolMessage(code, this.sync, Map<int, dynamic> body)
      : header = pack({UserKey.code: code, UserKey.sync: sync}),
        body = pack(body);

  Uint8List get length => pack(header.length + body.length);
  final Uint8List header;
  final Uint8List body;
  final int sync;

  String toString() => "l=$length h=$header b=$body";

  static TarantoolMessage select(
      {@required int spaceId,
      @required int indexId,
      @required int limit,
      @required int offset,
      @required TarantoolIterator iterator,
      @required List<int> key,
      @required int sync}) {
    final body = {
      UserKey.space_id: spaceId,
      UserKey.index_id: indexId,
      UserKey.limit: limit,
      UserKey.offset: offset,
      UserKey.iterator: iterator.code,
      UserKey.key: key
    };

    return new TarantoolMessage(UserCommand.select, sync, body);
  }

  static TarantoolMessage insert(
      {@required int spaceId, @required List tuple, @required int sync}) {
    final body = {UserKey.space_id: spaceId, UserKey.tuple: tuple};
    return new TarantoolMessage(UserCommand.insert, sync, body);
  }

  @override
  bool operator ==(other) {
    if (other is! TarantoolMessage) {
      return false;
    }
    final eq = const ListEquality(const IdentityEquality());
    return sync == other.sync &&
        eq.equals(header, other.header) &&
        eq.equals(body, other.body);
  }
}
