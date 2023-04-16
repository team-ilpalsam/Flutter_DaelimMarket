import 'dart:ui';

import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainAppbar {
  static Widget leadingOnly({
    required String title,
    required String leading,
    required VoidCallback leadingTap,
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
                child: GestureDetector(
                    onTap: leadingTap,
                    child: Image.asset(
                      leading,
                      alignment: Alignment.topLeft,
                      height: 18.h,
                    )),
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
    required String leading,
    required Widget action,
    required VoidCallback leadingTap,
    required VoidCallback actionTap,
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
              GestureDetector(
                onTap: leadingTap,
                child: Image.asset(
                  leading,
                  alignment: Alignment.topLeft,
                  height: 18.h,
                ),
              ),
              const Spacer(flex: 200),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 22.sp,
                  fontWeight: medium,
                  color: dmBlack,
                ),
              ),
              const Spacer(flex: 165),
              GestureDetector(
                onTap: actionTap,
                child: action,
              ),
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
