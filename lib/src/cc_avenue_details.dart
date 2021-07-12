class CCAvenueDetails {
  String transUrl;
  String rsaKeyUrl;
  String accessCode;
  String merchantId;
  String orderId;
  String currencyType;
  String amount;
  String cancelUrl;
  String redirectUrl;

  CCAvenueDetails.init(
      {required this.transUrl,
      required this.rsaKeyUrl,
      required this.accessCode,
      required this.merchantId,
      required this.orderId,
      required this.currencyType,
      required this.amount,
      required this.cancelUrl,
      required this.redirectUrl});

  Map<String, dynamic> toMap() {
    return {
      "transUrl": transUrl,
      "rsaKeyUrl": rsaKeyUrl,
      "accessCode": accessCode,
      "merchantId": merchantId,
      "orderId": orderId,
      "currencyType": currencyType,
      "amount": amount,
      "cancelUrl": cancelUrl,
      "redirectUrl": redirectUrl,
      "width": "0",
      "height": "0",
    };
  }
}
