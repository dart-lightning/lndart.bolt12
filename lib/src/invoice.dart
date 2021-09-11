import 'package:bolt12.dart/bolt12.dart';

// Class implementation of the Invoice
class Invoice extends Bolt12 {
  Invoice() : super(hrp: "lni");

  @override
  Bolt12 create() {
    return this;
  }
}

// Class implementation of the Invoice request.
class InvoiceRequest extends Bolt12 {
  InvoiceRequest() : super(hrp: "lnr");

  @override
  Bolt12 create() {
    return this;
  }
}
