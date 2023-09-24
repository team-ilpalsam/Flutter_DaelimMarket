import 'dart:ui';

import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/const/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../widgets/scroll_behavior.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dmWhite,
      body: SafeArea(
        child: CustomScrollView(
          scrollBehavior: MyBehavior(),
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
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
                        Center(
                          child: Image.asset(
                            textLessLogo,
                            width: 168.w,
                            height: 168.h,
                          ),
                        ),
                        Text(
                          '우리 학교만의 작은 장터',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Jalnan',
                            fontSize: 15.sp,
                            color: dmBlue,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          '대림마켓',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Jalnan',
                            fontSize: 15.sp,
                            color: dmBlue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 232.h,
                    ),
                    Column(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.toNamed('/register');
                            },
                            child: const BlueButton(text: '바로 시작하기')),
                        SizedBox(
                          height: 10.h,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/login');
                          },
                          child: Text(
                            '계정이 있으신가요?',
                            style: TextStyle(
                              fontWeight: bold,
                              fontSize: 13.sp,
                              color: dmGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    window.viewPadding.bottom > 0
                        ? SizedBox(
                            height: 18.h,
                          )
                        : SizedBox(
                            height: 50.h,
                          ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
