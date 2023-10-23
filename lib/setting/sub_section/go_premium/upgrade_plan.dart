import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/colors.dart';
import '../../../common/custom_buttom.dart';
import '../../../common/custom_text.dart';
import '../payment/payment_option.dart';

class UpgradePlan extends StatelessWidget {
  const UpgradePlan({super.key});

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
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  const SizedBox(width: 10),
                  const CustomText(
                    text: "Upgrade Plan",
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    textColor: Colors.black,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: CustomText(
                  text: 'Upgrade your Plan and enjoy \nfull access of our app',
                  textColor: Colors.grey,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 8),

              //body
              Expanded(child: mainBody()),

              //buttom
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const PaymentOption(),
                      ),
                    );
                  },
                  buttonText: 'Upgrade Plan',
                  sizeWidth: double.infinity,
                  sizeHeight: 55,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainBody() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          height: 400,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 6,
                spreadRadius: 1,
                color: Colors.black.withOpacity(0.3),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/upgrade_plan.png',
                height: 90,
              ),
              const SizedBox(height: 40),
              tile('All resume templates'),
              const SizedBox(height: 10),
              tile('Unlimited resume'),
              const SizedBox(height: 10),
              tile('Unlimited customization \noption'),
              const SizedBox(height: 10),
              tile('Unlimited pdf downloads'),
              const SizedBox(height: 10),
              tile('Non-recurring payment. \nPay Once'),
            ],
          ),
        ),
      ),
    );
  }

  Widget tile(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: Mycolors().blue,
            size: 25,
          ),
          SizedBox(width: 14),
          CustomText(
            text: title,
            maxline: 2,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
