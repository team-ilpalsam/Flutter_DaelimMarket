import 'dart:ui';

import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// 경고 SnackBar
class WarningSnackBar {
  static void show({
    required BuildContext context,
    required String text,
    double? paddingHorizontal = 0.0,
    double? paddingBottom,
  }) {
    var snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal!,
          ),
          child: Container(
            width: double.infinity,
            height: 62.h,
            margin: EdgeInsets.only(
              bottom: paddingBottom ??
                  (window.viewPadding.bottom > 0 ? 69.h : 100.h),
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

// 완료 SnackBar
class DoneSnackBar {
  static void show({
    required BuildContext context,
    required String text,
    double? paddingHorizontal = 0.0,
    double? paddingBottom,
  }) {
    var snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: paddingHorizontal!,
          ),
          child: Container(
            width: double.infinity,
            height: 62.h,
            margin: EdgeInsets.only(
              bottom: paddingBottom ??
                  (window.viewPadding.bottom > 0 ? 69.h : 100.h),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 18.25.h,
              horizontal: 21.25.w,
            ),
            decoration: BoxDecoration(
              color: dmGreen,
              borderRadius: BorderRadius.all(
                Radius.circular(5.r),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/icons/icon_accept.png',
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

// 정보 SnackBar
class InfoSnackBar {
  static void show({
    required String text,
    double? paddingHorizontal = 0.0,
    double? paddingBottom,
  }) {
    Get.snackbar(
      '', // 제목을 빈 문자열로 설정하거나 제목을 사용하지 않을 수 있습니다.
      text,
      backgroundColor: dmBlue,
      colorText: dmWhite,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      isDismissible: true, // 스낵바를 탭하여 닫을 수 있도록 설정
      margin: EdgeInsets.only(
        bottom: paddingBottom ?? (window.viewPadding.bottom > 0 ? 69.h : 100.h),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 18.25.h,
        horizontal: 21.25.w,
      ),
      animationDuration: const Duration(milliseconds: 300),
      borderRadius: 5.r,
      icon: Image.asset(
        'assets/images/icons/icon_info.png',
        width: 28.w,
        height: 28.h,
      ),
      shouldIconPulse: false, // 아이콘이 펄스 애니메이션을 사용하지 않도록 설정
    );
  }
}
