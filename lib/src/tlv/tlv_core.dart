import 'dart:typed_data';

import 'package:bolt12.dart/src/tlv/tlv_types.dart';
import 'package:tuple/tuple.dart';

class TLVUtils {
  static final Map<String, Function(ByteData)> _conversionToType = {
    "u64": (value) {
      var type = IntegerTLV(size: 8, bytes: value);
      return type.fromWire();
    },
    "u32": (value) {
      var type = IntegerTLV(size: 4, bytes: value);
      return type.fromWire();
    },
    "u16": (value) {
      var type = IntegerTLV(size: 2, bytes: value);
      return type.fromWire();
    },
    "u8": (value) {
      var type = IntegerTLV(size: 1, bytes: value);
      return type.fromWire();
    },
  };

  static final Map<String, Function(dynamic)> _conversionFromType = {
    "u64": (value) {
      var type = IntegerTLV(size: 8, value: value);
      return type.toWire();
    },
    "u32": (value) {
      var type = IntegerTLV(size: 4, value: value);
      return type.toWire();
    },
    "u16": (value) {
      var type = IntegerTLV(size: 2, value: value);
      return type.toWire();
    },
    "u8": (value) {
      var type = IntegerTLV(size: 1, value: value);
      return type.toWire();
    },
  };

  static Tuple2<dynamic, ByteData> fromWireToByte(ByteData buffer) {
    var type = ByteTLV(bytes: buffer);
    return type.fromWire();
  }

  static ByteData fromByteToWire(dynamic value) {
    var type = ByteTLV(value: value);
    return type.toWire();
  }

  static Tuple2<dynamic, ByteData> fromWireToInt(String type, ByteData value) {
    if (!_conversionToType.containsKey(type))
      throw Exception("Type %s unsupported");
    var function = _conversionToType[type]!;
    return function(value);
  }

  static ByteData fromIntToWire(String type, dynamic value) {
    if (!_conversionFromType.containsKey(type))
      throw Exception("Type %s unsupported");
    var function = _conversionFromType[type]!;
    return function(value);
  }

  static Tuple2<dynamic, ByteData> fromWireToBig(ByteData buffer) {
    var type = BigSizeTLV(bytes: buffer);
    return type.fromWire();
  }

  static ByteData fromBigToWire(dynamic value) {
    var type = BigSizeTLV(value: value);
    return type.toWire();
  }
}
