import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
//import 'package:mpesa_flutter_plugin/mpesa_flutter_plugin.dart';
import 'dart:convert';

import 'package:multitranslation/selectLanguage.dart';
import 'package:multitranslation/storage/keys.dart';
import 'package:multitranslation/storage/storage.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Future updatePaymentStatus() async {
    try {
      print(StorageServices.to.getString(userToken));
      final response = await http.post(
          Uri.parse("https://app.horumarkaal.app/api/auth/updatestatus"),
          body: jsonEncode({"is_paid": 1}),
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                "Bearer ${StorageServices.to.getString(userToken)}",
          });
      if (response.statusCode == 200) {
        var data = await jsonDecode(response.body);
        StorageServices.to.setString(
            key: "isPaid", value: data['user']['is_paid'].toString());
      } else {}
    } catch (e) {
      print("not updated");
    }
  }

  final TextEditingController _phoneNumberController = TextEditingController();
//   Future<void> lipaNaMpesa() async {
//     dynamic transactionInitialisation;
//     try {
//       transactionInitialisation =
//           await MpesaFlutterPlugin.initializeMpesaSTKPush(
//               businessShortCode: "174379",
//               transactionType: TransactionType.CustomerPayBillOnline,
//               amount: 1.0,
//               partyA: "Place your phonenumber here eg..25472.........9",
//               partyB: "174379",
// //Lipa na Mpesa Online ShortCode
//               callBackURL: Uri(
//                   scheme: "https",
//                   host: "mpesa-requestbin.herokuapp.com",
//                   path: "/1hhy6391"),
// //This url has been generated from http://mpesa-requestbin.herokuapp.com/?ref=hackernoon.com for test purposes
//               accountReference: "Horumarkaal App",
//               phoneNumber: "Place your phonenumber here eg..25472.........9",
//               baseUri: Uri(scheme: "https", host: "sandbox.safaricom.co.ke"),
//               transactionDesc: "purchase",
//               passKey:
//                   "Get Your Pass Key from Test Credentials its random eg..'c893059b1788uihh'...");
// //This passkey has been generated from Test Credentials from Safaricom Portal

//       return transactionInitialisation;
//     } catch (e) {
//       print("CAUGHT EXCEPTION: " + e.toString());
//     }
//   }

  Future<void> _makePayment() async {
    const String apiUrl = "https://api.waafipay.net/asm";

    Map<String, dynamic> requestBody = {
      "schemaVersion": "1.0",
      "requestId": "unique_requestid",
      "timestamp": "client_timestamp",
      "channelName": "WEB",
      "serviceName": "API_PURCHASE",
      "serviceParams": {
        "merchantUid": "M0913556",
        "apiUserId": "1007227",
        "apiKey": "API-1979741904AHX",
        "paymentMethod": "MWALLET_ACCOUNT",
        "payerInfo": {"accountNo": _phoneNumberController.text},
        "transactionInfo": {
          "referenceId": "RF123444",
          "invoiceId": "INV1280215",
          "amount": "1",
          "currency": "USD",
          "description": "direct purchase"
        }
      }
    };
    //  {
    //   "schemaVersion": "1.0",
    //   "requestId": "R1571118025", // "R"+currentTime
    //   "timestamp": "1571118025", // currentTime
    //   "channelName": "WEB", // waa static
    //   "serviceName": "API_PURCHASE",
    //   "serviceParams": {
    //     "merchantUid": "M0913556",
    //     "apiUserId": "1007227",
    //     "apiKey": "API-1979741904AHX",
    //     "paymentMethod": "MWALLET_ACCOUNT",
    //     "payerInfo": {
    //       "accountNo": "252615563595" // start country prefix "252"+615515000
    //     },
    //     "transactionInfo": {
    //       "referenceId": "REF1571118025", // "REF"+currentTime
    //       "invoiceId": "INV1571118025", // "INV"+currentTime
    //       "amount": 1,
    //       "currency": "USD",
    //       "description": "test payment"
    //     }
    //   }
    // };

    try {
      EasyLoading.show(status: "Wait please....");
      final response = await http.post(Uri.parse(apiUrl),
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        EasyLoading.dismiss();
        if (responseData['responseMsg'] == "RCS_SUCCESS") {
          // Payment approved, show toast and move to the next screen
          _showToast("Payment Approved");
          updatePaymentStatus();
          // Navigate to the next screen
          EasyLoading.dismiss();

          // ignore: use_build_context_synchronously
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SelectLanguageScreen()));
        } else {
          // Payment failed, show toast with the error message
          _showToast(responseData['responseMsg']);
          EasyLoading.dismiss();
        }
      } else {
        // Handle other status codes if needed
        EasyLoading.dismiss();

        _showToast("Error: ${response.statusCode}");
      }
    } catch (error) {
      // Handle errors during the API call
      EasyLoading.dismiss();

      _showToast("Error: $error");
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "The one-time payment for using the multi-translation app is \$10",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _phoneNumberController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Enter phone number (252xxxxxxxxx)",
                  hintStyle: TextStyle(color: Colors.black),
                  labelStyle: TextStyle(color: Colors.black),
                ),
                keyboardType: TextInputType.number,
                maxLength: 12,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Validate and make payment
                    // if (_phoneNumberController.text.length == 12 &&
                    //     _phoneNumberController.text.startsWith("252")

                    //     ) {
                    _makePayment();
                    // }
                    // else {
                    //   _showToast("Invalid phone number");
                    // }
                  },
                  child: const Text("Make Payment"),
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     // Validate and make payment
                //     // if (_phoneNumberController.text.length == 12 &&
                //     //     _phoneNumberController.text.startsWith("252")

                //     //     ) {
                //     await lipaNaMpesa();
                //     // }
                //     // else {
                //     //   _showToast("Invalid phone number");
                //     // }
                //   },
                //   child: Text("Make Payment with mpesa"),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
