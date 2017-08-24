class TarantoolIterator {
  TarantoolIterator._(this.code);

  final int code;

  static TarantoolIterator get eq => new TarantoolIterator._(0);

  static TarantoolIterator get req => new TarantoolIterator._(1);

  static TarantoolIterator get all => new TarantoolIterator._(2);

  static TarantoolIterator get lt => new TarantoolIterator._(3);

  static TarantoolIterator get le => new TarantoolIterator._(4);

  static TarantoolIterator get ge => new TarantoolIterator._(5);

  static TarantoolIterator get gt => new TarantoolIterator._(6);

  static TarantoolIterator get bitsAllSet => new TarantoolIterator._(7);

  static TarantoolIterator get bitsAnySet => new TarantoolIterator._(8);

  static TarantoolIterator get bitsAllNotSet => new TarantoolIterator._(9);

  static TarantoolIterator get overlap => new TarantoolIterator._(10);

  static TarantoolIterator get neighbor => new TarantoolIterator._(11);
}
