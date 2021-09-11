import 'dart:typed_data';

import 'package:bolt12.dart/src/tlv/tlv_types.dart';
import 'package:tuple/tuple.dart';

// Class wrapper that contains all status field to make
// all tlv format conversion.
class TLVUtils {
  // The Map that contains all the mapping function to
  // convert a type to a stream of byte.
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

  // The map that contains all the mapping function to
  // convert a stream of data to a value and return the remain stream of
  // bytes.
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

  // Convert from a stream of byte to byte
  static Tuple2<dynamic, ByteData> fromWireToByte(ByteData buffer) {
    var type = ByteTLV(bytes: buffer);
    return type.fromWire();
  }

  // convert from a byte to a stream of bytes
  static ByteData fromByteToWire(dynamic value) {
    var type = ByteTLV(value: value);
    return type.toWire();
  }

  // Use the mapping _conversionToType to convert the stream of byte
  // in the value, and return the remain stream of byte.
  static Tuple2<dynamic, ByteData> fromWireToInt(String type, ByteData value) {
    if (!_conversionToType.containsKey(type))
      throw Exception("Type %s unsupported");
    var function = _conversionToType[type]!;
    return function(value);
  }

  // Use the mapping with _conversionFromType to convert a value
  // into a stream of bytes.
  static ByteData fromIntToWire(String type, dynamic value) {
    if (!_conversionFromType.containsKey(type))
      throw Exception("Type %s unsupported");
    var function = _conversionFromType[type]!;
    return function(value);
  }

  // Convert a stream of byte to the big type, a big type it is like
  // a bitcoin var int!
  static Tuple2<dynamic, ByteData> fromWireToBig(ByteData buffer) {
    var type = BigSizeTLV(bytes: buffer);
    return type.fromWire();
  }

  // convert a big value (that is a value encoded inside like a varint in bircoin)
  // and return the stream of data.
  static ByteData fromBigToWire(dynamic value) {
    var type = BigSizeTLV(value: value);
    return type.toWire();
  }
}
