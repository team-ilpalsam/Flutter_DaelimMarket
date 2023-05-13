import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

welcomeInputDeco() => InputDecoration(
      isDense: true,
      hintStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 18.sp,
        fontWeight: medium,
        color: dmBlack,
      ),
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

mainInputDeco(String? hintText) => InputDecoration(
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
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          width: 1.w,
          color: dmDarkGrey,
        ),
      ),
    );

var mainInputTextDeco = TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 18.sp,
  fontWeight: medium,
  color: dmBlack,
);

searchInputDeco({String? hintText = ''}) => InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 18.sp,
        fontWeight: medium,
        color: dmBlack,
      ),
      contentPadding: EdgeInsets.only(
        bottom: 4.h,
        left: 3.w,
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
