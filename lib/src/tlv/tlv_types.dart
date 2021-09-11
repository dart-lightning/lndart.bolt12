// Implementation of the TLV format described in the lightning-rfc
// https://github.com/rustyrussell/lightning-rfc/blob/guilt/offers/01-messaging.md#type-length-value-format
import 'dart:typed_data';
import 'package:tuple/tuple.dart';

import '../../tlv_format.dart';

// Basic TLV type to give an interface to all others types.
abstract class BasicTypeTLV<T> {
  final T? value;
  final ByteData? bytes;

  BasicTypeTLV(this.value, this.bytes);

  void checkToRead() {
    if (bytes == null) throw Exception("Specify buffer to make read operation");
  }

  void checkToWrite() {
    if (value == null)
      throw Exception("Specify value to make the write operation");
  }

  // Convert the buffer of type into the value
  // and return the remains buffers
  // assume that bytes in the type is not null
  Tuple2<dynamic, ByteData> fromWire();

  // Convert the value into a stream of bytes
  // assume that value in the type is not null
  ByteData toWire();
}

class IntegerTLV extends BasicTypeTLV<int> {
  final int size;

  IntegerTLV({int? value, ByteData? bytes, required this.size})
      : super(value, bytes);

  @override
  Tuple2<dynamic, ByteData> fromWire() {
    checkToRead();
    assert(bytes!.lengthInBytes >= size, "truncated");
    var value = bytes!.buffer.asUint8List(0, size - 1);
    var toInt = 0;
    switch (value.length) {
      case 1:
        toInt = ByteData.view(value.buffer).getInt8(0);
        break;
      case 2:
        toInt = ByteData.view(value.buffer).getInt16(0);
        break;
      case 4:
        toInt = ByteData.view(value.buffer).getInt32(0);
        break;
      case 8:
        toInt = ByteData.view(value.buffer).getInt64(0);
    }
    return Tuple2(toInt, bytes!.buffer.asByteData(size, bytes!.lengthInBytes));
  }

  @override
  ByteData toWire() {
    checkToWrite();
    var bytes = ByteData(size);
    switch (size) {
      case 1:
        bytes.setInt8(0, value!);
        break;
      case 2:
        bytes.setInt16(0, value!);
        break;
      case 4:
        bytes.setInt32(0, value!);
        break;
      case 8:
        bytes.setInt64(0, value!);
        break;
      default:
        throw Exception("Int type of the size ${size} not recognize");
    }
    return bytes;
  }
}

class ByteTLV extends IntegerTLV {
  ByteTLV({int? value, ByteData? bytes, int size = 1})
      : super(value: value, bytes: bytes, size: size);

  @override
  Tuple2<dynamic, ByteData> fromWire() => super.fromWire();

  @override
  ByteData toWire() => super.toWire();
}

class BigSizeTLV extends BasicTypeTLV<int> {
  BigSizeTLV({int? value, ByteData? bytes}) : super(value, bytes);

  ByteData _append(ByteData from, ByteData data) {
    from.buffer.asUint8List().addAll(data.buffer.asUint8List());
    return ByteData.sublistView(from);
  }

  @override
  Tuple2<dynamic, ByteData> fromWire() {
    super.checkToRead();
    var bytesConv = TLVUtils.fromWireToByte(bytes!);
    var minVal;
    var type = "u16";
    Tuple2<dynamic, ByteData> res;
    switch (bytesConv.item1) {
      case 0xFD:
        minVal = 0xFD;
        break;
      case 0xFE:
        minVal = 0xFE;
        type = "u32";
        break;
      case 0xFF:
        minVal = 0xFF;
        type = "u64";
        break;
      default:
        throw Exception("Hex on the type unsupported");
    }
    res = TLVUtils.fromWireToInt(type, bytesConv.item2);
    if (res.item1 < minVal) throw Exception("non minimal-encoded bigsize");
    return res;
  }

  @override
  ByteData toWire() {
    super.checkToWrite();
    if (value! < 0xFD)
      return TLVUtils.fromByteToWire(value);
    else if (value! <= 0xFFFF)
      return _append(
          TLVUtils.fromByteToWire(0xFD), TLVUtils.fromIntToWire("u16", value!));
    else if (value! <= 0xFFFFFFFF)
      return _append(
          TLVUtils.fromByteToWire(0xFE), TLVUtils.fromIntToWire("u32", value!));
    else
      return _append(
          TLVUtils.fromByteToWire(0xFF), TLVUtils.fromIntToWire("u64", value!));
  }
}
