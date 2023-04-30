import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/screen/widgets/welcome_appbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

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
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: CustomScrollView(
              scrollBehavior: MyBehavior(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      WelcomeAppbar(
                        image: 'assets/images/icons/icon_close.png',
                        title: '로그인',
                        onTap: () {
                          context.go('/welcome');
                        },
                      ),
                      // Contents
                      SizedBox(
                        height: 101.h,
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
                        cursorHeight: 24.h,
                        style: welcomeInputTextDeco,
                        decoration: welcomeInputDeco,
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
                        height: 46.h,
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
                        cursorHeight: 24.h,
                        obscureText: true,
                        style: welcomeInputTextDeco,
                        decoration: welcomeInputDeco,
                        cursorColor: dmBlack,
                      ),
                      SizedBox(
                        height: 29.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/login/forgot');
                        },
                        child: Text(
                          '비밀번호를 잊으셨나요?',
                          style: TextStyle(
                            fontWeight: bold,
                            fontSize: 13.sp,
                            color: dmGrey,
                          ),
                        ),
                      ),

                      // Bottom
                      const Expanded(child: SizedBox()),
                      emailController.text.length >= 3 &&
                              passwordController.text.length >= 4
                          ? GestureDetector(
                              onTap: () async {
                                if (!emailController.text
                                    .contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
                                  WarningSnackBar.show(
                                      context: context,
                                      text: '이메일에 포함할 수 없는 문자가 있어요.');
                                } else {
                                  try {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email:
                                                '${emailController.text}@email.daelim.ac.kr',
                                            password: passwordController.text)
                                        .then(
                                      (value) async {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        if (value.user!.emailVerified == true) {
                                          await const FlutterSecureStorage()
                                              .deleteAll();
                                          await const FlutterSecureStorage().write(
                                              key: 'email',
                                              value:
                                                  '${emailController.text}@email.daelim.ac.kr');
                                          await const FlutterSecureStorage()
                                              .write(
                                                  key: 'password',
                                                  value:
                                                      passwordController.text);
                                          await const FlutterSecureStorage()
                                              .write(
                                                  key: 'id',
                                                  value: emailController.text);
                                          await const FlutterSecureStorage()
                                              .write(
                                                  key: 'uid',
                                                  value: value.user!.uid);
                                          context.go('/main');
                                        } else {
                                          WarningSnackBar.show(
                                              context: context,
                                              text: '이메일 인증이 안 된 계정이에요.');
                                        }
                                        return value;
                                      },
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    switch (e.code) {
                                      case 'user-not-found':
                                      case 'wrong-password':
                                        WarningSnackBar.show(
                                            context: context,
                                            text: '일치하는 정보가 없어요.');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        break;
                                      case 'user-disabled':
                                        WarningSnackBar.show(
                                            context: context,
                                            text: '사용할 수 없는 계정이에요.');
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
                                  : const BlueButton(text: '로그인'),
                            )
                          : const BlueButton(text: '로그인', color: dmLightGrey),
                      bottomPadding,
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
