import 'package:flutter/material.dart';

import 'colors.dart';
import 'custom_text.dart';


class CustomSettingTile extends StatelessWidget {
  CustomSettingTile({
    required this.icon,
    required this.title,
    // required this.dec,
    super.key,
  });

  IconData icon;
  String title;
  // String dec;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Mycolors().blue,
              ),
              const SizedBox(
                width: 15,
              ),
              CustomText(
                text: title,
                fontWeight: FontWeight.w500,
              ),
              const Spacer(),
              const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Colors.grey,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // const SizedBox(
          //   height: 15,
          // ),
          // CustomText(
          //   text: dec,
          //   textColor: Colors.grey[600],
          //   maxline: 2,
          // ),
          // const SizedBox(
          //   height: 15,
          // ),
          // Divider(
          //   indent: 0,
          //   color: Colors.grey[350],
          // )
        ],
      ),
    );
  }
}
