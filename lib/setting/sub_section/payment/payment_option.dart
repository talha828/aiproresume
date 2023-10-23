import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import '../../../common/colors.dart';
import '../../../common/custom_buttom.dart';
import '../../../common/custom_text.dart';

import 'package:pay/pay.dart';

import 'payment_configuration.dart';
import 'stripepayment.dart';

class PaymentOption extends StatefulWidget {
  const PaymentOption({super.key});

  @override
  State<PaymentOption> createState() => _PaymentOptionState();
}

int _selectedPayment = 0;

class _PaymentOptionState extends State<PaymentOption> {
  _PaymentOptionState() {
   // getpaymentKeys();
  }

  getpaymentKeys() async {
    //Assign publishable key to flutter_stripe
    Stripe.publishableKey =
        "pk_test_51O3C7yAsKkRyudp24y1BqvnwQo0uRx9ze4Oy5i040ZRE2mtyV05xbe0BtZS24j7nun9XuwllaXlAJNBV8lfc3cWc00VUsPF4mz";

    //Load our .env file that contains our Stripe Secret key
    await dotenv.load(fileName: "assets/.env");
  }

  paymentNow() async {
    await StripePaymentTest().makePayment(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 10),
                  const CustomText(
                    text: "Payment Method",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Select your payment method',
                  textColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 25),

              //body
              Expanded(child: _mainbody()),

              //button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    switch (_selectedPayment) {
                      case 1:
                        paymentNow();
                        // Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(
                        //     builder: (context) => Payment(),
                        //   ),
                        // );
                        break;
                      case 2:
                        payPalPayment();
                        break;
                    }
                  },
                  buttonText: 'NEXT',
                  sizeWidth: double.infinity,
                  sizeHeight: 55,
                ),
              ),

              // Example pay button configured using a string
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainbody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            //Visa
            // customPaymentCardButton(
            //   'Visa',
            //   'assets/svg/visa.svg',
            //   0,
            // ),
            // const SizedBox(height: 12),

            //Stripe
            customPaymentCardButton(
              'Stripe',
              'assets/svg/stripe.svg',
              1,
            ),
            const SizedBox(height: 12),

            //paypal
            customPaymentCardButton(
              'Paypal',
              'assets/svg/paypal.svg',
              2,
            ),
            const SizedBox(height: 12),

            // //Payoneer
            // customPaymentCardButton(
            //   'Payoneer',
            //   'assets/svg/payoneer.svg',
            //   3,
            // ),
            // const SizedBox(height: 12),

            // //Google
            // customPaymentCardButton(
            //   'Google Pay',
            //   'assets/svg/googlecard.svg',
            //   4,
            // ),
            const SizedBox(height: 12),
            GooglePayButton(
              paymentConfiguration: _googlePayConfigFuture,
              paymentItems: _paymentItems,
              type: GooglePayButtonType.buy,
              margin: const EdgeInsets.only(top: 15.0),
              onPaymentResult: onGooglePayResult,
              loadingIndicator: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Card Payment Widget
  Widget customPaymentCardButton(String title, String assetName, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedPayment = index;
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        side: BorderSide(
          width: (_selectedPayment == index) ? 1.5 : 0.5,
          color: (_selectedPayment == index) ? Mycolors().blue! : Colors.grey,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              children: [
                if (_selectedPayment == index)
                  // ignore: deprecated_member_use
                  SvgPicture.asset(
                    'assets/svg/circle.svg',
                    color: Mycolors().green,
                    height: 12,
                  ),
                const SizedBox(
                  width: 10,
                ),
                CustomText(text: title, fontSize: 18),
                const Spacer(),
                SvgPicture.asset(
                  assetName,
                  fit: BoxFit.cover,
                  width: 120,
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  payPalPayment() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
            sandboxMode: true,
            clientId:
                "AZfbTGOduU8cDWlV62_X54sg91pOdgl5CRHn7LVDnh29cs1YJc_3EvQW4aOj25RSwv8y4_OP_xpK5JpK",
            secretKey:
                "EOzcIgCD3moJDBF4LXEjbXMxqvu9yVR_328-jKzVLYSE7A7ebIuvaqswv1iPRJs8b4zw-MWI8LUuis1s",
            returnURL: "https://samplesite.com/return",
            cancelURL: "https://samplesite.com/cancel",
            transactions: [
              {
                "amount": {
                  "total": 200,
                  "currency": "USD",
                  "details": {
                    "subtotal": 200,
                    "shipping": '0',
                    "shipping_discount": 0
                  }
                },
                "description": "The payment transaction description.",
                // "payment_options": {
                //   "allowed_payment_method":
                //       "INSTANT_FUNDING_SOURCE"
                // },
                "item_list": {
                  "items": [
                    {
                      "name": "A demo product",
                      "quantity": 1,
                      "price": 200,
                      "currency": "USD"
                    }
                  ],

                  // shipping address is not required though
                  "shipping_address": {
                    "recipient_name": "Jane Foster",
                    "line1": "Travis County",
                    "line2": "",
                    "city": "Austin",
                    "country_code": "US",
                    "postal_code": "73301",
                    "phone": "+00000000",
                    "state": "Texas"
                  },
                }
              }
            ],
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              print("onSuccess: $params");
            },
            onError: (error) {
              print("onError: $error");
            },
            onCancel: (params) {
              print('cancelled: $params');
            }),
      ),
    );
  }

  final _paymentItems = [
    PaymentItem(
      label: 'Total',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    )
  ];
  late PaymentConfiguration _googlePayConfigFuture;
  @override
  void initState() {
    super.initState();
    // _googlePayConfigFuture =
    //     PaymentConfiguration.fromAsset('default_google_pay_config.json');
    _googlePayConfigFuture =
        PaymentConfiguration.fromJsonString(defaultGooglePay);
  }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }
}
