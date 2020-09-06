import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/models.dart';

class PaymentsService {
  static final String squareApplicationId = 'sq0idp-v9L6FHpv4e7iAf315K7UnA';

  static Future<void> executePaymentFlow(
      Function onCardEntryComplete, Function onCardEntryCancel) async {
    InAppPayments.setSquareApplicationId(squareApplicationId);
    InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: (CardDetails cardDetails) {
          InAppPayments.completeCardEntry(
              onCardEntryComplete: onCardEntryComplete);
        },
        onCardEntryCancel: onCardEntryCancel);
  }
}
