import 'response.dart';

class TarantoolError extends Error {
  TarantoolError(this.code, this.description);

  static fromResponse(Response response) =>
      new TarantoolError(response.errorCode, response.error);

  final code;
  final description;

  String toString() => description;
}
