import 'package:bip340/bip340.dart' as bip340;
import 'package:crypto/crypto.dart';
import 'dart:convert';

// This class is a wrapper class and it used the package bip340
// However, this module is developed with a OOP paradigm, and the
// bip340 it is only a collection of function without state.
// Make a wrapper around the dependencies it is always good to make easy
// the migration to another module
class HashFunction {
  late Hash _hasher;

  HashFunction() {
    _hasher = sha256 as Hash;
  }

  /// Generates a Schnorr signature using the BIP-340 scheme.
  ///
  /// privateKey must be 32-bytes hex-encoded, i.e., 64 characters.
  /// message must also be 32-bytes hex-encoded (a hash of the _actual_ message).
  /// aux must be 32-bytes random bytes, generated at signature time.
  /// It returns the signature as a string of 64 bytes hex-encoded, i.e., 128 characters.
  /// For more information on BIP-340 see bips.xyz/340.
  String sign(String privateKey, String message, String aux) {
    return bip340.sign(privateKey, message, aux);
  }

  // FIXME: Review this
  Digest sha256(String privateKey, String message) {
    var tagBytes = utf8.encode(privateKey);
    var digest = _hasher.convert(tagBytes).bytes;
    var tag = _hasher.convert(digest + digest).bytes;
    return _hasher.convert(tag);
  }
}
