import 'dart:ui';

import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/screen/widgets/welcome_appbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotChangeScreen extends StatefulWidget {
  const ForgotChangeScreen({super.key});

  @override
  State<ForgotChangeScreen> createState() => _ForgotChangeScreen();
}

class _ForgotChangeScreen extends State<ForgotChangeScreen> {
  late TextEditingController passwordController;
  late TextEditingController confirmController;

  @override
  void initState() {
    passwordController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    confirmController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: dmWhite,
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const WelcomeAppbar(
                        image: 'assets/images/icons/icon_close.png',
                        title: '비밀번호 변경',
                      ),
                      // Contents
                      SizedBox(
                        height: 101.h,
                      ),
                      Text(
                        '비밀번호',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 21.sp,
                          fontWeight: bold,
                          color: dmBlack,
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      TextField(
                        controller: passwordController,
                        onChanged: (value) => debugPrint('비밀번호: $value'),
                        cursorHeight: 24.h,
                        obscureText: true,
                        style: welcomeInputTextDeco,
                        decoration: welcomeInputDeco,
                        cursorColor: dmBlack,
                      ),
                      SizedBox(
                        height: 63.5.h,
                      ),
                      Text(
                        '비밀번호 확인',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 21.sp,
                          fontWeight: bold,
                          color: dmBlack,
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      TextField(
                        controller: confirmController,
                        onChanged: (value) => debugPrint('비밀번호 확인: $value'),
                        cursorHeight: 24.h,
                        obscureText: true,
                        style: welcomeInputTextDeco,
                        decoration: welcomeInputDeco,
                        cursorColor: dmBlack,
                      ),
                      SizedBox(
                        height: 63.5.h,
                      ),
                      // Bottom
                      const Expanded(child: SizedBox()),
                      passwordController.text.length >= 8 &&
                              confirmController.text.length >= 8
                          ? GestureDetector(
                              onTap: () {
                                if (passwordController.text !=
                                    confirmController.text) {
                                  WarningSnackBar.show(
                                      context: context, text: '비밀번호가 맞지 않아요.');
                                } else {
                                  context.go('/');
                                }
                              },
                              child: const BlueButton(text: '변경 완료'),
                            )
                          : const BlueButton(
                              text: '인증번호 받기', color: dmLightGrey),
                      window.viewPadding.bottom > 0 //비밀번호 변경 완료만 해주세여
                          ? SizedBox(
                              height: 13.h,
                            )
                          : SizedBox(
                              height: 45.h,
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
  }
}
