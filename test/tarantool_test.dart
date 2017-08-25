@Skip("should be run manually")

import 'package:tarantool/tarantool.dart';
import 'package:test/test.dart';

const Matcher isTarantoolError = const _TarantoolError();

class _TarantoolError extends TypeMatcher {
  const _TarantoolError() : super("TarantoolError");

  bool matches(item, Map matchState) => item is TarantoolError;
}

void main() {
  final host = "localhost";
  final port = 3301;

  test("connect", () async {
    final client = new TarantoolClient(host, port);
    expect(client.connect(), completion(startsWith("Tarantool")));
  });

  test("select without socket", () async {
    final client = new TarantoolClient(host, port);
    expect(client.select(999, 0, 10, 0, TarantoolIterator.all, [0]),
        throwsA(anything));
  });

  test("select invalid space", () async {
    final client = new TarantoolClient(host, port);
    await client.connect();

    expect(client.select(444, 0, 10, 0, TarantoolIterator.all, [0]),
        throwsA(isTarantoolError));
  });

  test("select", () async {
    final client = new TarantoolClient(host, port);
    await client.connect();

    final response =
        await client.select(999, 0, 10, 0, TarantoolIterator.all, [0]);
    expect(
        response,
        unorderedEquals([
          [41, 'a'],
          [42, 'b']
        ]));
  });

  test("multiple select", () async {
    final client = new TarantoolClient(host, port);
    await client.connect();

    final response1 =
        await client.select(999, 0, 10, 0, TarantoolIterator.all, [0]);
    final response2 =
        await client.select(999, 0, 10, 0, TarantoolIterator.eq, [41]);
    final response3 =
        await client.select(999, 0, 10, 0, TarantoolIterator.eq, [42]);

    expect(
        response1,
        unorderedEquals([
          [41, 'a'],
          [42, 'b']
        ]));
    expect(
        response2,
        unorderedEquals([
          [41, 'a']
        ]));
    expect(
        response3,
        unorderedEquals([
          [42, 'b']
        ]));
  });

  test("multiple immediate select", () async {
    final client = new TarantoolClient(host, port);
    await client.connect();

    final response1 = client.select(999, 0, 10, 0, TarantoolIterator.all, [0]);
    final response2 = client.select(999, 0, 10, 0, TarantoolIterator.eq, [41]);
    final response3 = client.select(999, 0, 10, 0, TarantoolIterator.eq, [42]);

    expect(
        response1,
        completion(unorderedEquals([
          [41, 'a'],
          [42, 'b']
        ])));
    expect(
        response2,
        completion(unorderedEquals([
          [41, 'a']
        ])));
    expect(
        response3,
        completion(unorderedEquals([
          [42, 'b']
        ])));
  });

  test("insert", () async {
    final client = new TarantoolClient(host, port);
    await client.connect();
    final response = await client.insert(999, [43, "hello, world!"]);

    expect(
        response,
        unorderedEquals([
          [43, "hello, world!"]
        ]));
  });

  test("insert duplicate key", () async {
    final client = new TarantoolClient(host, port);
    await client.connect();
    await client.insert(999, [44, "hello, world!"]);
    expect(
        client.insert(999, [44, "hello, world!"]), throwsA(isTarantoolError));
  });
}
