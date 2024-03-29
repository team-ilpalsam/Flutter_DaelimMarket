import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/screen/widgets/welcome_appbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RegisterVefiryScreen extends StatelessWidget {
  final String email;

  const RegisterVefiryScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      widget: SizedBox(
                        height: 18.h,
                      ),
                      title: '이메일 인증',
                    ),
                    SizedBox(
                      height: 23.h,
                    ),
                    Text(
                      '$email 주소에\n인증 링크를 전송했어요!',
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18.sp,
                        fontWeight: bold,
                        color: dmBlack,
                      ),
                    ),
                    // Contents
                    SizedBox(
                      height: 104.h,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/icons/icon_mail.png',
                        width: 216.w,
                        height: 194.h,
                      ),
                    ),
                    Center(
                      child: Text(
                        '인증 메일이 안 보이시나요?\n정크 메일함에 있을 수도 있어요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 13.sp,
                          fontWeight: bold,
                          color: dmLightGrey,
                        ),
                      ),
                    ),
                    // Bottom
                    const Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        Get.offAllNamed('/login');
                      },
                      child: const BlueButton(
                        text: '인증 후 로그인',
                        color: dmBlue,
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
    );
  }
}
