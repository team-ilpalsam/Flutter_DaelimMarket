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
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotScreen extends StatelessWidget {
  ForgotScreen({super.key});

  final RxString _email = ''.obs;
  final RxBool _isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        // 키보드 위에 입력 창 띄우기 여부
        resizeToAvoidBottomInset: true,
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
                      WelcomeAppbar(
                        // Loading 상태일 경우 뒤로가기 방지
                        widget: Obx(
                          () => _isLoading.value
                              ? SizedBox(
                                  height: 18.h,
                                )
                              : Image.asset(
                                  'assets/images/icons/icon_close.png',
                                  height: 18.h,
                                ),
                        ),
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
                      Obx(
                        () => TextField(
                          enabled: _isLoading.value ? false : true,
                          cursorHeight: 24.h,
                          style: welcomeInputTextDeco,
                          decoration: welcomeInputDeco(),
                          cursorColor: dmBlack,
                          onChanged: (value) {
                            _email.value = value;
                          },
                        ),
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
                      Obx(
                        () => _email.value.length >= 3
                            ? GestureDetector(
                                onTap: onTapResetPassword,
                                child: Obx(
                                  () => _isLoading.value
                                      ? const LoadingButton(
                                          color: dmLightGrey,
                                        )
                                      : const BlueButton(text: '인증메일 받기'),
                                ),
                              )
                            : const BlueButton(
                                text: '인증메일 받기',
                                color: dmLightGrey,
                              ),
                      ),
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

  Future<void> onTapResetPassword() async {
    // 이메일 유효성 검사
    if (!_email.value.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
      WarningSnackBar.show(text: '이메일에 포함할 수 없는 문자가 있어요.');
    } else {
      // Loading 상태를 true로 변경
      _isLoading.value = true;
      try {
        // Firebase에 비밀번호 초기화 메일 전송 요청
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: "${_email.value}@email.daelim.ac.kr")
            .then((value) {
          // 성공 시
          // Loading 상태를 false로 변경
          _isLoading.value = false;
          // WelcomeScreen으로 이동하는 알림창 띄우기
          AlertDialogWidget.oneButton(
            content: "해당 주소에 링크를 전송했어요.\n메일 확인 후 로그인 해주세요.",
            button: "확인",
            action: () {
              Get.toNamed('/welcome');
            },
            barrierDismissible: false, // 바깥 부분 눌렀을 때 알림 창 닫는지의 여부
          );
        });
      } on FirebaseAuthException catch (e) {
        // 실패(Exception) 시
        switch (e.code) {
          case "invalid-email":
            WarningSnackBar.show(text: '이메일 주소를 다시 확인해주세요.');
            _isLoading.value = false;
            break;
          case "user-not-found":
            WarningSnackBar.show(text: '일치하는 정보가 없어요.');
            _isLoading.value = false;
            break;
          default:
            WarningSnackBar.show(text: e.code.toString());
            _isLoading.value = false;
            break;
        }
      }
    }
    return;
  }
}
