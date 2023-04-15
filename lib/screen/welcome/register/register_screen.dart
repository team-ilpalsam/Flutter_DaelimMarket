import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/screen/widgets/welcome_title.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmController;

  bool _isLoading = false;

  @override
  void initState() {
    emailController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

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
    emailController.dispose();
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
                      const WelcomeTitle(
                        image: 'assets/images/icons/icon_close.png',
                        title: '회원가입',
                      ),
                      // Contents
                      SizedBox(
                        height: 55.h,
                      ),
                      Text(
                        '이메일',
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
                        controller: emailController,
                        onChanged: (value) => debugPrint('이메일: $value'),
                        style: inputTextDeco,
                        decoration: inputDeco,
                        cursorColor: dmBlack,
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Text(
                        '@email.daelim.ac.kr',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 24.sp,
                          fontWeight: bold,
                          color: dmBlack,
                        ),
                      ),
                      SizedBox(
                        height: 44.h,
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
                        obscureText: true,
                        style: inputTextDeco,
                        decoration: inputDeco,
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
                        style: inputTextDeco,
                        decoration: inputDeco,
                        cursorColor: dmBlack,
                      ),
                      SizedBox(
                        height: 63.5.h,
                      ),
                      // Bottom
                      const Expanded(child: SizedBox()),
                      emailController.text.length >= 4 &&
                              passwordController.text.length >= 6 &&
                              confirmController.text.length >= 6
                          ? GestureDetector(
                              onTap: () async {
                                if (!emailController.text
                                    .contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
                                  WarningSnackBar.show(
                                      context: context,
                                      text: '이메일에 포함할 수 없는 문자가 있어요.');
                                } else if (passwordController.text !=
                                    confirmController.text) {
                                  WarningSnackBar.show(
                                      context: context, text: '비밀번호가 맞지 않아요.');
                                } else {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email:
                                                '${emailController.text}@email.daelim.ac.kr',
                                            password: passwordController.text)
                                        .then((value) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      FirebaseFirestore.instance
                                          .collection('user')
                                          .doc(value.user!.uid)
                                          .set({
                                        'nickName': "",
                                        'id': emailController.text,
                                        'email':
                                            '${emailController.text}@email.daelim.ac.kr',
                                        'profile_image': "",
                                      });
                                      context.goNamed(
                                        'registerAuthLink',
                                        queryParams: {
                                          'email':
                                              ('${emailController.text}@email.daelim.ac.kr'),
                                        },
                                      );
                                      return value;
                                    });
                                    FirebaseAuth.instance.currentUser
                                        ?.sendEmailVerification();
                                  } on FirebaseAuthException catch (e) {
                                    switch (e.code) {
                                      case 'weak-password':
                                        WarningSnackBar.show(
                                            context: context,
                                            text: '비밀번호 보안을 신경써주세요.');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        break;
                                      case 'email-already-in-use':
                                        WarningSnackBar.show(
                                            context: context,
                                            text: '이미 존재하는 계정이에요.');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        break;
                                      case 'invalid-email':
                                        WarningSnackBar.show(
                                            context: context,
                                            text: '이메일 주소 형식을 다시 확인해주세요.');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        break;
                                      case 'operation-not-allowed':
                                        WarningSnackBar.show(
                                            context: context,
                                            text: '허용되지 않은 작업이에요.');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        break;
                                      default:
                                        WarningSnackBar.show(
                                            context: context,
                                            text: e.code.toString());
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        break;
                                    }
                                  }
                                }
                              },
                              child: _isLoading
                                  ? const LoadingButton(
                                      color: dmLightGrey,
                                    )
                                  : const BlueButton(text: '계정 등록하기'),
                            )
                          : const BlueButton(
                              text: '계정 등록하기', color: dmLightGrey),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
