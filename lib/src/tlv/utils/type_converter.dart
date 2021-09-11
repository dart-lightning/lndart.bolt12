import 'dart:typed_data';

Uint8List bigIntToUint8List(BigInt bigInt) =>
    bigIntToByteData(bigInt).buffer.asUint8List();

ByteData bigIntToByteData(BigInt bigInt) {
  final data = ByteData((bigInt.bitLength / 8).ceil());
  var _bigInt = bigInt;

  for (var i = 1; i <= data.lengthInBytes; i++) {
    data.setUint8(data.lengthInBytes - i, _bigInt.toUnsigned(8).toInt());
    _bigInt = _bigInt >> 8;
  }

  return data;
}

// Source: https://stackoverflow.com/a/57536472/14933807
Uint8List int32bytes(int value) =>
    Uint8List(4)..buffer.asInt32List()[0] = value;

// Source: https://stackoverflow.com/a/57536472/14933807
Uint8List int32BigEndianBytes(int value) =>
    Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);
