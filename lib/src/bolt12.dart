import 'package:bolt12.dart/src/core/bolt12_decoder.dart';
import 'package:bolt12.dart/src/utils/hash_function.dart';
import 'package:crypto/crypto.dart';

import 'core/bolt12_content.dart';
import 'core/bolt12_encoder.dart';

// Dart implementation of BOLT12
// this class is the interface of the BOLT12, and it should contains
// all the method to make operation specified in the BOLT12
abstract class Bolt12 {
  // hrp it is the prefix of the bol12
  // - "lno" -> An offers
  // - "lnr" -> An invoice request
  // - "lni" -> A normal invoice
  final String hrp;

  late Bolt12Encoder _encoder;
  late Bolt12Decoder _decoder;
  late HashFunction _hashFunction;

  Bolt12({required this.hrp}) {
    _encoder = Bolt12Encoder();
    _decoder = Bolt12Decoder();
    _hashFunction = HashFunction();
  }

  // Compute the hash function with the bolt12 procedure
  // described in the specification https://github.com/rustyrussell/lightning-rfc/blob/guilt/offers/12-offer-encoding.md#encoding
  // with the reference implementation in python at the following
  // link https://github.com/vincenzopalazzo/bolt12/blob/master/python/src/bolt12/bolt12.py#L23
  Digest bolt12Hash(String key, String message) {
    return _hashFunction.sha256(key, message);
  }

  // decode bolt 12 from a string of bytes
  Bolt12Content decoder(String content) {
    return _decoder.decode(content);
  }

  // encode a bolt 12 into string
  String encode() {
    // TODO complete with the map calls
    return _encoder.encode(this.hrp, {}, {}, {});
  }

  // Create a bolt12
  Bolt12 create();
}
