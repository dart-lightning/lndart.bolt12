import 'dart:typed_data';

import 'package:bolt12.dart/bolt12.dart';
import 'package:bolt12.dart/bolt_utils.dart';

// Dart implementation of the Offers.
class Offers extends Bolt12 {
  Offers({ByteData? byteStr}) : super(hrp: "lno") {
    if (byteStr != null)
      //TODO make merkle of the byteStr
      byteStr = null; // TODO remove this line, only to compile dart code
  }

  @override
  Bolt12 create() {
    return this;
  }

  // Make a sanity check of the offer, in case of some error
  // the result contains the reason of the failure. Otherwise
  // if the result is true, the reason is null
  Bolt12Result check() {
    //TODO make check of the offers
    return Bolt12Result(result: true);
  }
}
