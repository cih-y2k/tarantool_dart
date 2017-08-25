# Dart client for Tarantool Database

Implemented connection to db and insert/select queries.

## Usage example

```dart
final client = new TarantoolClient(host, port);
await client.connect();
await client.insert(444, [44, "hello, world!"])
await client.select(444, 0, 10, 0, TarantoolIterator.all, [0]);

```