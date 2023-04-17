import 'dart:ui';

import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainAppbar {
  static Widget leadingOnly({
    required String title,
    required Widget leading,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        window.viewPadding.top > 0
            ? SizedBox(height: 7.h)
            : SizedBox(height: 71.h),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: leading,
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 22.sp,
                  fontWeight: medium,
                  color: dmBlack,
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Divider(
          thickness: 1.w,
          color: dmGrey,
        ),
      ],
    );
  }

  static Widget leadingAndAction({
    required String title,
    required Widget leading,
    required Widget action,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        window.viewPadding.top > 0
            ? SizedBox(height: 7.h)
            : SizedBox(height: 71.h),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(flex: 2, child: SizedBox(child: leading)),
              Expanded(
                flex: 6,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 22.sp,
                    fontWeight: medium,
                    color: dmBlack,
                  ),
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(child: action))),
            ],
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Divider(
          thickness: 1.w,
          color: dmGrey,
        ),
      ],
    );
  }
}
