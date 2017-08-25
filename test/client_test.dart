import 'package:mockito/mockito.dart';
import 'package:tarantool/src/client.dart';
import 'package:tarantool/src/connection.dart';
import 'package:tarantool/src/iterator.dart';
import 'package:tarantool/src/message.dart';
import 'package:test/test.dart';

void main() {
  MockConnection connection;
  TarantoolClient client;

  setUp(() {
    connection = new MockConnection();
    client = new TarantoolClient.withConnection(connection);
  });

  test("client connect interacts with connection", () {
    when(connection.connect()).thenReturn("ServerInfo");
    expect(client.connect(), completion("ServerInfo"));
  });

  test("client insert creates correct message", () async {
    await client.insert(999, [1, 2, 3]);

    final message =
        TarantoolMessage.insert(spaceId: 999, tuple: [1, 2, 3], sync: 0);
    expect(verify(connection.send(captureAny)).captured.single, message);
  });

  test("client select creates correct message", () async {
    await client.select(555, 0, 100, 50, TarantoolIterator.all, [1]);

    final message = TarantoolMessage.select(
        spaceId: 555,
        indexId: 0,
        limit: 100,
        offset: 50,
        iterator: TarantoolIterator.all,
        key: [1],
        sync: 0);
    expect(verify(connection.send(captureAny)).captured.single, message);
  });
}

class MockConnection extends Mock implements TarantoolConnection {}
