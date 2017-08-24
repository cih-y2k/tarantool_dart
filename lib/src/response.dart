class Response {
  const Response({this.sync, this.payload, this.error, this.errorCode});

  final int sync;

  final String error;
  final int errorCode;
  final dynamic payload;

  String toString() =>
      "Response{sync = $sync, payload = $payload, error = $error, errorCode = $errorCode}";

  bool isSuccess() => errorCode == null;
}
