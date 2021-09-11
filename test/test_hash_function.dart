import 'package:test/test.dart';

void main() {
  // This test include a sanity check to know if the procedure
  // to compute the sha256 with the dar lib it is good
  test("Test sha256", () {
    expect("actualValue", "matchingValue");
  });

  // This test include sanity check to know if the procedure to compute
  // the bolt12 hash with dart it is good.
  test("Test bolt12 hash", () {
    expect("actualValue", "matchingValue");
  });
}
