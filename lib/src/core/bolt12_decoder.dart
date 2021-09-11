import 'package:bech32/bech32.dart';
import 'package:bolt12.dart/src/core/bolt12_content.dart';

class Bolt12DecoderException implements Exception {
  String cause;
  Bolt12DecoderException(this.cause);
}

// Utils class that implement the decoder logic of the BOLT 12
class Bolt12Decoder {
  // Contains all the possible encoding method
  // with the bolt12 you can see what is the encoding
  // with the prefix.
  // - "lno" -> An offers
  // - "lnr" -> An invoice request
  // - "lni" -> A normal invoice
  late Map<String, Function> _methods;
  late Bech32Codec _bech32codec;

  Bolt12Decoder() {
    _bech32codec = Bech32Codec();
    _methods["lno"] = () {
      print("lno");
    };
    _methods["lnr"] = () {
      print("lnr");
    };
    _methods["lni"] = () {
      print("lni");
    };
  }

  // Return a bech32 object that contains all the data
  // encoded inside the string.
  // - bolt12Str: It is the bol12 string encoded in bech32 convention
  Bech32 fromBech32(String bolt12Str) {
    return _bech32codec.decode(bolt12Str);
  }

  Bolt12Content decode(String content) {
    _methods.keys.forEach((prefix) {
      if (content.startsWith(prefix)) {
        var function = _methods[prefix]!;
        return function(content);
      }
    });
    throw Bolt12DecoderException("Content $content has a unknown prefix");
  }
}
