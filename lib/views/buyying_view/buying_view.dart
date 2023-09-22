import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kartal/kartal.dart';
import 'package:namazvakitleri/views/buyying_view/pay_view.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:pay/pay.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../widgets/selected_buy_container.dart';
import '../auth/login_page.dart';
import '../auth/sign_up.dart';
import '../prayer_times_view.dart';
import 'payment_configurations.dart' as payment_configurations;

import 'ads_view.dart';

List<PaymentItem> paymentItems = [
  PaymentItem(
    label: 'Toplam',
    amount: '0',
    status: PaymentItemStatus.final_price,
  )
];

class BuyyingView extends StatefulWidget {
  @override
  _BuyyingViewState createState() => _BuyyingViewState();
}

class _BuyyingViewState extends State<BuyyingView> {
  bool isSelected = true;
  bool isSelected2 = false;
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
    final List<Widget> screenList = [
      // ignore: todo
      //TODO:
      // projectler gönderilecek

      AdsView()
    ];
    return Scaffold(
      backgroundColor: Color.fromRGBO(27, 41, 86, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.xmark),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 300, child: AdsView()),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 16,
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectedConteiner(
                        isMon: false,
                        planTitle: "Yıllık Plan",
                        price: 300,
                        selected: isSelected2,
                        onPressed: () => setState(() {
                          isSelected = false;
                          isSelected2 = true;
                          print(isSelected2);
                          setState(() {
                            paymentItems = [
                              PaymentItem(
                                label: 'Toplam',
                                amount: '300',
                                status: PaymentItemStatus.final_price,
                              )
                            ];
                          });
                        }),
                      ),
                      SelectedConteiner(
                        isMon: true,
                        planTitle: "Aylık Plan",
                        price: 28,
                        selected: isSelected,
                        onPressed: () => setState(() {
                          isSelected = true;
                          isSelected2 = false;
                          print(isSelected2);
                        }),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(27, 41, 86, 1),
                          ),
                          onPressed: () {
                            login == "0"
                                ? QuickAlert.show(
                                    cancelBtnText: "Üye Girişi",
                                    cancelBtnTextStyle: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                    showCancelBtn: true,
                                    onCancelBtnTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: "Üyelik Eksik",
                                    text: 'Öncelikle Üye Girişi Yapmalısınız',
                                    confirmBtnText: "Üye Ol",
                                    onConfirmBtnTap: () =>
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SignUp())),
                                    confirmBtnColor: Colors.blueAccent)
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PaySampleApp(
                                              title: isSelected2
                                                  ? "1 Yıllık Abone Olarak Tüm Reklamları Kaldırıyorsunuz. Bunun için ödeme yaparak devam ediniz"
                                                  : "Aylık Abone Olarak Tüm Reklamları Kaldırıyorsunuz. Bunun için ödeme yaparak devam ediniz",
                                              paymentItems: paymentItems,
                                            )));
                            // context.navigateToPage(PaySampleApp(
                            //   title: isSelected2
                            //       ? "1 Yıllık Abone Olarak Tüm Reklamları Kaldırıyorsunuz. Bunun için ödeme yaparak devam ediniz"
                            //       : "Aylık Abone Olarak Tüm Reklamları Kaldırıyorsunuz. Bunun için ödeme yaparak devam ediniz",
                            //   paymentItems: paymentItems,
                            // ));
                          },
                          child: Text("Devam Et"))),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                //   child: SizedBox(
                //       width: double.infinity,
                //       child: ElevatedButton(
                //           style: ElevatedButton.styleFrom(
                //               backgroundColor: Colors.white),
                //           onPressed: () {},
                //           child: Text(
                //             "Satın Almayı Geri Yükle",
                //             style: Theme.of(context).textTheme.button,
                //           ))),
                // ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'main.buyyingText'.tr(),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
