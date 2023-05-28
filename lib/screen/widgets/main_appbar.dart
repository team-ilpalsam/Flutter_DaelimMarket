import 'dart:ui';

import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'named_widget.dart';

class MainAppbar {
  static Widget show({
    required String title,
    required Widget leading,
    required Widget action,
    VoidCallback? titleOnTap,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        topPadding,
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
              Expanded(
                flex: 15,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    child: leading,
                  ),
                ),
              ),
              Expanded(
                flex: 70,
                child: GestureDetector(
                  onTap: titleOnTap,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 22.sp,
                      fontWeight: medium,
                      color: dmBlack,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(child: action),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        divider,
      ],
    );
  }
}
