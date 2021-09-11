// Exception used in the Bol12Encoder
import 'package:bech32/bech32.dart';

class Bolt12EncoderException implements Exception {
  String cause;
  Bolt12EncoderException(this.cause);
}

// Utils class that implement the encoder logic of the BOLT12
class Bolt12Encoder {
  late Bech32Codec _bech32codec;

  Bolt12Encoder() {
    _bech32codec = Bech32Codec();
  }

  // Make a bech32 conversion with the following data:
  // - htp: It is the prefix of the bech32.
  // - data: data to be encode inside this bech32
  String toBech32(String hrp, List<int> data) {
    hrp = hrp + '1';
    return _bech32codec.encode(Bech32(hrp, data));
  }

  String encode(String hrp, Map<int, List<dynamic>> tvlTable,
      Map<int, dynamic> values, Map<int, List<int>> unknowns) {
    // TODO: wrap all the map with a tlv helper.
    return toBech32(hrp, []);
  }
}
