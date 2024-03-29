import 'dart:io';
import 'dart:ui';

import 'package:daelim_market/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget divider = Container(
  width: double.infinity,
  height: 1.h,
  color: dmGrey,
);

Widget topPadding = Platform.isAndroid == true
    ? SizedBox(
        height: 15.h,
      )
    : const SizedBox();

Widget bottomPadding = window.viewPadding.bottom > 0
    ? SizedBox(
        height: 18.h,
      )
    : SizedBox(
        height: 45.h,
      );
