import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var welcomeInputDeco = InputDecoration(
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(
    vertical: 0,
  ),
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: dmDarkGrey,
      width: 2.w,
    ),
  ),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(
      color: dmDarkGrey,
      width: 2.w,
    ),
  ),
);

var welcomeInputTextDeco = TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 24.sp,
  fontWeight: bold,
  color: dmBlack,
);

mainInputDeco(String? hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 18.sp,
      fontWeight: medium,
      color: dmBlack,
    ),
    contentPadding: EdgeInsets.symmetric(
      vertical: 10.h,
      horizontal: 10.w,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(
        width: 1.w,
        color: dmLightGrey,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(
        width: 1.w,
        color: dmLightGrey,
      ),
    ),
  );
}

var mainInputTextDeco = TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 18.sp,
  fontWeight: medium,
  color: dmBlack,
);
