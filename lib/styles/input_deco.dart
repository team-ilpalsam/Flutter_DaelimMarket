import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var inputDeco = InputDecoration(
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

var inputTextDeco = TextStyle(
  fontFamily: 'Pretendard',
  fontSize: 24.sp,
  fontWeight: bold,
  color: dmBlack,
);
