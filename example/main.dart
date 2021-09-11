import 'package:bolt12.dart/bolt12.dart';

void main() {
  var bolt12 = Bolt12(hrp: "hrp");
  print(bolt12.encode());
}
