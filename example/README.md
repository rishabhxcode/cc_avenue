# cc_avenue_example

Demonstrates how to use the cc_avenue plugin.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Code
###### Call CcAvenue.cCAvenueInit() as async 
```
try {
       await CcAvenue.cCAvenueInit(
        transUrl: 'https://secure.ccavenue.com/transaction/initTrans',
        accessCode: '4YRUXLSRO20O8NIH',
        amount: '10',
        cancelUrl: 'http://122.182.6.216/merchant/ccavResponseHandler.jsp',
        currencyType: 'INR',
        merchantId: '2',
        orderId: '519',
        redirectUrl: 'http://122.182.6.216/merchant/ccavResponseHandler.jsp',
        rsaKeyUrl: 'https://secure.ccavenue.com/transaction/jsp/GetRSA.jsp'
      );
      
```
