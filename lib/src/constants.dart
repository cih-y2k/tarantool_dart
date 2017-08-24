class UserKey {
  static const code = 0x00;
  static const sync = 0x01;
  static const schema_id = 0x05;
  static const space_id = 0x10;
  static const index_id = 0x11;
  static const limit = 0x12;
  static const offset = 0x13;
  static const iterator = 0x14;
  static const key = 0x20;
  static const tuple = 0x21;
  static const function_name = 0x22;
  static const username = 0x23;
  static const expression = 0x27;
  static const ops = 0x28;
  static const data = 0x30;
  static const error = 0x31;
}

class UserCommand {
  static const select = 0x01;
  static const insert = 0x02;
  static const replace = 0x03;
  static const update = 0x04;
  static const delete = 0x05;
  static const call_16 = 0x06;
  static const auth = 0x07;
  static const eval = 0x08;
  static const upsert = 0x09;
  static const call = 0x0a;
}

class AdminCommand {
  static const ping = 0x40;
}
