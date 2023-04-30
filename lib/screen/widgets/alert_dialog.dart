import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlertDialogWidget {
  static void oneButton({
    required BuildContext context,
    required String content,
    required String button,
    required VoidCallback action,
    barrierDismissible = true,
  }) {
    int nextLineCount = 0;
    for (int i = 0; i < content.length; i++) {
      if (content[i] == '\n') {
        nextLineCount++;
      }
    }
    showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      context: context,
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
            width: 319.w,
            height: (146 + (25 * nextLineCount)).h,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: dmBlack,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(20.r),
                color: dmWhite,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 33.h,
                  ),
                  Text(
                    content,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18.sp,
                      fontWeight: bold,
                      color: dmBlack,
                      height: 1.3.h,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                    ),
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
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void twoButtons({
    required BuildContext context,
    required String content,
    required List<String> button,
    required List<Color> color,
    required List<VoidCallback> action,
    barrierDismissible = true,
  }) {
    int nextLineCount = 0;
    for (int i = 0; i < content.length; i++) {
      if (content[i] == '\n') {
        nextLineCount++;
      }
    }
    showDialog(
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.r),
            ),
          ),
          content: SizedBox(
            width: 319.w,
            height: (146 + (25 * nextLineCount)).h,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: dmBlack,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(20.r),
                color: dmWhite,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 33.h,
                  ),
                  Text(
                    content,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 18.sp,
                      fontWeight: bold,
                      color: dmBlack,
                      height: 1.3.h,
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
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
                          fit: FlexFit.loose,
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
                  SizedBox(
                    height: 20.h,
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
