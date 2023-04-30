import 'package:daelim_market/screen/widgets/alert_dialog.dart';
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
import 'package:go_router/go_router.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreen();
}

class _ForgotScreen extends State<ForgotScreen> {
  late TextEditingController emailController;

  bool _isLoading = false;

  @override
  void initState() {
    emailController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
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
              scrollBehavior: MyBehavior(),
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
                        title: '비밀번호 찾기',
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
                        onChanged: (value) => debugPrint('이메일: $value'),
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
                      // Bottom
                      const Expanded(child: SizedBox()),
                      emailController.text.length >= 3
                          ? GestureDetector(
                              onTap: () async {
                                if (!emailController.text
                                    .contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
                                  WarningSnackBar.show(
                                      context: context,
                                      text: '이메일에 포함할 수 없는 문자가 있어요.');
                                } else {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  try {
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email:
                                                "${emailController.text}@email.daelim.ac.kr")
                                        .then((value) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      AlertDialogWidget.oneButton(
                                        context: context,
                                        content:
                                            "해당 주소에 링크를 전송했어요.\n메일 확인 후 로그인 해주세요.",
                                        button: "확인",
                                        action: () {
                                          context.go('/welcome');
                                        },
                                        barrierDismissible: false,
                                      );
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    switch (e.code) {
                                      case "auth/invalid-email":
                                        WarningSnackBar.show(
                                            context: context,
                                            text: '이메일 주소를 다시 확인해주세요.');
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        break;
                                      case "auth/user-not-found":
                                        WarningSnackBar.show(
                                            context: context,
                                            text: '일치하는 정보가 없어요.');
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
                                return;
                              },
                              child: _isLoading
                                  ? const LoadingButton(
                                      color: dmLightGrey,
                                    )
                                  : const BlueButton(text: '인증메일 받기'),
                            )
                          : const BlueButton(
                              text: '인증메일 받기', color: dmLightGrey),
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
