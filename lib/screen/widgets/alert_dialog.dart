import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AlertDialogWidget {
  static void oneButton({
    required String content,
    required String button,
    required VoidCallback action,
    barrierDismissible = true,
  }) {
    showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.r),
            ),
          ),
          content: Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: dmBlack,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(20.r),
                color: dmWhite,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 15.w,
                  right: 15.w,
                  top: 33.h,
                  bottom: 20.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: 290.w),
                      child: Text(
                        content,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18.sp,
                          fontWeight: bold,
                          color: dmBlack,
                          height: 1.3.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    SizedBox(
                      width: 290.w,
                      height: 38.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: action,
                              child: Container(
                                height: 38.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    5.r,
                                  ),
                                  color: dmBlue,
                                ),
                                child: Center(
                                  child: Text(
                                    button,
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 18.sp,
                                      fontWeight: medium,
                                      color: dmWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static void twoButtons({
    required String content,
    required List<String> button,
    required List<Color> color,
    required List<VoidCallback> action,
    barrierDismissible = true,
  }) {
    showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.r),
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: dmBlack,
                width: 2.w,
              ),
              borderRadius: BorderRadius.circular(20.r),
              color: dmWhite,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: 15.w,
                right: 15.w,
                top: 33.h,
                bottom: 20.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: 275.w),
                    child: Text(
                      content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18.sp,
                        fontWeight: bold,
                        color: dmBlack,
                        height: 1.3.h,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  SizedBox(
                    width: 290.w,
                    height: 38.h,
                    child: Row(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: action[0],
                            child: Container(
                              height: 38.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5.r,
                                ),
                                color: color[0],
                              ),
                              alignment: Alignment.center,
                              child: Center(
                                child: Text(
                                  button[0],
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18.sp,
                                    fontWeight: medium,
                                    color: dmWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Flexible(
                          child: GestureDetector(
                            onTap: action[1],
                            child: Container(
                              height: 38.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  5.r,
                                ),
                                color: color[1],
                              ),
                              alignment: Alignment.center,
                              child: Center(
                                child: Text(
                                  button[1],
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18.sp,
                                    fontWeight: medium,
                                    color: dmWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
