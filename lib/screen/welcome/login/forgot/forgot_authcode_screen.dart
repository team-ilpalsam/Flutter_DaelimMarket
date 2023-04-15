import 'dart:ui';

import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/screen/widgets/welcome_title.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgotAuthCodeScreen extends StatefulWidget {
  final String email;

  const ForgotAuthCodeScreen({
    super.key,
    required this.email,
  });

  @override
  State<ForgotAuthCodeScreen> createState() => _ForgotAuthCodeScreen();
}

class _ForgotAuthCodeScreen extends State<ForgotAuthCodeScreen> {
  late TextEditingController authCodeController = TextEditingController();

  @override
  void initState() {
    authCodeController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    authCodeController.dispose();
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
                        image: 'assets/images/icons/icon_back.png',
                        title: '이메일 인증',
                      ),
                      SizedBox(
                        height: 23.h,
                      ),
                      Text(
                        '${widget.email} 주소에\n인증 번호를 전송했어요!',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18.sp,
                          fontWeight: bold,
                          color: dmBlack,
                        ),
                      ),
                      // Contents
                      SizedBox(
                        height: 74.h,
                      ),
                      Text(
                        '인증 번호',
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
                        controller: authCodeController,
                        onChanged: (value) => debugPrint('인증번호: $value'),
                        keyboardType: TextInputType.number,
                        cursorHeight: 24.h,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: inputTextDeco,
                        decoration: inputDeco,
                        cursorColor: dmBlack,
                      ),
                      // Bottom
                      const Expanded(child: SizedBox()),
                      authCodeController.text.length == 6
                          ? GestureDetector(
                              onTap: () {
                                context.pushNamed('changePassword');
                              },
                              child: const BlueButton(text: '입력 완료'))
                          : const BlueButton(text: '입력 완료', color: dmLightGrey),
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
