import 'dart:ui';

import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountDoneScreen extends StatefulWidget {
  const AccountDoneScreen({super.key});

  @override
  State<AccountDoneScreen> createState() => _AccountDoneScreenState();
}

class _AccountDoneScreenState extends State<AccountDoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dmBlue,
      body: SafeArea(
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
                  ),
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
                          'assets/images/logo/daelimmarket_textless.png',
                          width: 168.w,
                          height: 168.h,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 249.h,
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const BlueButton(
                      text: '대림마켓 입장',
                      color: dmWhite,
                      textColor: dmBlue,
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              ),
              window.viewPadding.bottom > 0
                  ? SizedBox(
                      height: 13.h,
                    )
                  : SizedBox(
                      height: 45.h,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
