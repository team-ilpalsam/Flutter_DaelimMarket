import 'dart:ui';

import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WarningSnackBar {
  static void show({
    required BuildContext context,
    required String text,
  }) {
    var snackBar = SnackBar(
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Container(
            width: double.infinity,
            height: 62.h,
            margin: EdgeInsets.only(
              bottom: window.viewPadding.bottom > 0 ? 69.h : 100.h,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 18.25.h,
              horizontal: 21.25.w,
            ),
            decoration: BoxDecoration(
              color: dmRed,
              borderRadius: BorderRadius.all(
                Radius.circular(5.r),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icons/icon_deny.png',
                  width: 28.w,
                  height: 28.h,
                ),
                SizedBox(width: 14.25.w),
                Text(
                  text,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16.sp,
                    fontWeight: bold,
                    color: dmWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
