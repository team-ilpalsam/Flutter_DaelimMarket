import 'dart:async';

import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/const/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AccountDoneScreen extends StatelessWidget {
  AccountDoneScreen({super.key});

  final RxBool isBlue = false.obs;

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 500), () {
      isBlue.value = true;
    });

    return Scaffold(
      body: Obx(
        () => AnimatedContainer(
          duration: const Duration(seconds: 2),
          color: isBlue.value ? dmBlue : dmWhite,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(child: SizedBox()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '모든 준비가 끝났어요!',
                        style: TextStyle(
                          fontFamily: 'Jalnan',
                          fontSize: 28.sp,
                          color: dmWhite,
                        ),
                      ).animate().fadeIn(
                          delay: 2500.ms,
                          duration: 500.ms,
                          curve: Curves.easeIn),
                      SizedBox(
                        height: 25.h,
                      ),
                      Center(
                        child: Container(
                          width: 182.w,
                          height: 182.h,
                          decoration: const BoxDecoration(
                            color: dmWhite,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              textLessLogo,
                              width: 168.w,
                              height: 168.h,
                            ),
                          ),
                        ),
                      ).animate().fadeIn(
                          delay: 2500.ms,
                          duration: 500.ms,
                          curve: Curves.easeIn),
                    ],
                  ),
                  SizedBox(
                    height: 249.h,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.offAllNamed('/');
                        },
                        child: const BlueButton(
                          text: '대림마켓 입장',
                          color: dmWhite,
                          textColor: dmBlue,
                        ),
                      ).animate().fadeIn(
                          delay: 3500.ms,
                          duration: 1000.ms,
                          curve: Curves.easeIn),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                  bottomPadding,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
