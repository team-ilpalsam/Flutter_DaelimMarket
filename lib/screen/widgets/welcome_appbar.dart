import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomeAppbar extends StatelessWidget {
  final Widget widget;
  final String title;
  final VoidCallback? onTap;

  const WelcomeAppbar({
    super.key,
    required this.widget,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 71.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: GestureDetector(
              onTap: onTap ??
                  () {
                    Get.back();
                  },
              child: widget),
        ),
        SizedBox(
          height: 52.h,
        ),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 32.sp,
            fontWeight: bold,
            color: dmBlack,
          ),
        )
      ],
    );
  }
}
