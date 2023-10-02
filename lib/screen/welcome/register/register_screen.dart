import 'package:cloud_firestore/cloud_firestore.dart';
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

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RxBool _isLoading = false.obs;

  final RxString _email = ''.obs;
  final RxString _password = ''.obs;
  final RxString _confirm = ''.obs;

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        // 키보드 위에 입력 창 띄우기 여부
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
                      Obx(
                        () => TextField(
                          enabled: _isLoading.value ? false : true,
                          cursorHeight: 24.h,
                          obscureText: true, // 비밀번호 가리기
                          style: welcomeInputTextDeco,
                          decoration: welcomeInputDeco(),
                          cursorColor: dmBlack,
                          onChanged: (value) {
                            _password.value = value;
                          },
                        ),
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
                      Obx(
                        () => TextField(
                          enabled: _isLoading.value ? false : true,
                          cursorHeight: 24.h,
                          obscureText: true, // 비밀번호 가리기
                          style: welcomeInputTextDeco,
                          decoration: welcomeInputDeco(),
                          cursorColor: dmBlack,
                          onChanged: (value) {
                            _confirm.value = value;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 63.5.h,
                      ),

                      // Bottom
                      const Expanded(child: SizedBox()),
                      // 이메일 TextField의 글자 수가 3 글자 이상
                      Obx(
                        () => _email.value.length >= 3 &&
                                // 비밀번호 TextField의 글자 수가 3 글자 이상
                                _password.value.length >= 4 &&
                                // 비밀번호 확인 TextField의 글자 수가 3 글자 이상
                                _confirm.value.length >= 4
                            ? GestureDetector(
                                onTap: onTapRegister,
                                child: _isLoading.value
                                    ? const LoadingButton(
                                        color: dmLightGrey,
                                      )
                                    : const BlueButton(text: '계정 등록하기'),
                              )
                            : const BlueButton(
                                text: '계정 등록하기',
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

  Future<void> onTapRegister() async {
    // 이메일 유효성 검사
    if (!_email.value.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
      WarningSnackBar.show(text: '이메일에 포함할 수 없는 문자가 있어요.');
    }
    // 비밀번호와 비밀번호 확인 일치 검사
    else if (_password.value != _confirm.value) {
      WarningSnackBar.show(
        text: '비밀번호가 맞지 않아요.',
      );
    } else {
      try {
        // Loading 상태를 true로 변경
        _isLoading.value = true;
        // Firebase에 회원가입 요청
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: '${_email.value}@email.daelim.ac.kr',
                password: _password.value)
            .then((value) {
          // 성공 시
          // Loading 상태를 false로 변경
          _isLoading.value = false;
          // Firebase Firestore에 정보 저장 요청
          FirebaseFirestore.instance
              // user 컬렉션 내
              .collection('user')
              // 사용자의 UID 문서 생성
              .doc(value.user!.uid)
              // 다음과 같은 정보를 저장
              .set({
            'nickName': "", // 닉네임
            'id': _email.value, // ID
            'email': '${_email.value}@email.daelim.ac.kr', // 이메일
            'profile_image': "", // 프로필 사진
            'posts': [], // 포스트 내역
            'watchlist': [], // 관심 내역
            'token': '', // 토큰
          });
          // Firebase chat 컬렉션에 추가
          FirebaseFirestore.instance
              // chat 컬렉션 내
              .collection('chat')
              // 사용자의 UID 문서 생성
              .doc(value.user!.uid)
              .set({
            'daelimmarket': [
              {
                'send_time': DateTime.now(),
                'sender': 'daelimmarket',
                'type': 'text',
                'text': '추가해줘서 고마워요!\n다른 판매자들과 채팅을 시작해보아요!',
              }
            ],
            'read_time': {},
          });
          // 회원가입 후 이메일 인증 안내 페이지로 이동
          Get.offNamed(
            '/register/authlink',
            parameters: {
              'email': '${_email.value}@email.daelim.ac.kr',
            },
          );
          return value;
        });
        // 이메일 인증 메일 전송
        FirebaseAuth.instance.currentUser?.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        // 실패(Exception) 시
        switch (e.code) {
          case 'weak-password':
            WarningSnackBar.show(
              text: '비밀번호 보안을 신경써주세요.',
            );
            _isLoading.value = false;
            break;
          case 'email-already-in-use':
            WarningSnackBar.show(
              text: '이미 존재하는 계정이에요.',
            );
            _isLoading.value = false;
            break;
          case 'invalid-email':
            WarningSnackBar.show(
              text: '이메일 주소 형식을 다시 확인해주세요.',
            );
            _isLoading.value = false;
            break;
          case 'operation-not-allowed':
            WarningSnackBar.show(
              text: '허용되지 않은 작업이에요.',
            );
            _isLoading.value = false;
            break;
          default:
            WarningSnackBar.show(
              text: e.code.toString(),
            );
            _isLoading.value = false;
            break;
        }
      }
    }
  }
}
