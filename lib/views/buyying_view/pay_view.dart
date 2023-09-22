/// Copyright 2023 Google LLC
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///     https://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kartal/kartal.dart';
import 'package:pay/pay.dart';

import 'ads_view.dart';
import 'payment_configurations.dart' as payment_configurations;

class PaySampleApp extends StatefulWidget {
  PaySampleApp({Key? key, required this.paymentItems, required this.title})
      : super(key: key);
  final List<PaymentItem> paymentItems;
  final String title;
  @override
  _PaySampleAppState createState() => _PaySampleAppState();
}

class _PaySampleAppState extends State<PaySampleApp> {
  late final Future<PaymentConfiguration> _googlePayConfigFuture;

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture =
        PaymentConfiguration.fromAsset('default_google_pay_config.json');
  }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(27, 41, 86, 1),
        appBar: AppBar(
          title: const Text('Satın Al'),
        ),
        body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(height: 300, child: AdsView()),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                widget.title,
                style: context.textTheme.titleMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Column(
                children: [
                  // Example pay button configured using an asset
                  FutureBuilder<PaymentConfiguration>(
                      future: _googlePayConfigFuture,
                      builder: (context, snapshot) => snapshot.hasData
                          ? SizedBox(
                              height: 52,
                              width: double.infinity,
                              child: GooglePayButton(
                                paymentConfiguration: snapshot.data!,
                                paymentItems: widget.paymentItems,
                                type: GooglePayButtonType.buy,
                                margin: const EdgeInsets.only(top: 15.0),
                                onPaymentResult: onGooglePayResult,
                                loadingIndicator: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()),
                  // Example pay button configured using a string
                  SizedBox(
                    height: 52,
                    width: double.infinity,
                    child: ApplePayButton(
                      paymentConfiguration: PaymentConfiguration.fromJsonString(
                          payment_configurations.defaultApplePay),
                      paymentItems: widget.paymentItems,
                      style: ApplePayButtonStyle.black,
                      type: ApplePayButtonType.buy,
                      margin: const EdgeInsets.only(top: 15.0),
                      onPaymentResult: onApplePayResult,
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15)
                ],
              )
            ]));
  }
}
