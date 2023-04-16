import 'dart:ui';

import 'package:daelim_market/screen/widgets/alert_dialog.dart';
import 'package:daelim_market/screen/widgets/button.dart';
import 'package:daelim_market/screen/widgets/welcome_appbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:daelim_market/styles/input_deco.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({
    super.key,
  });

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  late TextEditingController nickNameController = TextEditingController();

  @override
  void initState() {
    nickNameController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    nickNameController.dispose();
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
                        title: '계정 설정',
                      ),
                      SizedBox(
                        height: 23.h,
                      ),
                      Text(
                        '게시물에는 닉네임으로 표시돼요!',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18.sp,
                          fontWeight: bold,
                          color: dmBlack,
                        ),
                      ),
                      // Contents
                      SizedBox(
                        height: 50.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              AlertDialogWidget.twoButtons(
                                context: context,
                                content: "testtest",
                                button: ["앨범에서 선택", "카메라로 촬영"],
                                color: [dmBlue, dmBlue],
                                action: [
                                  () {
                                    Navigator.pop(context);
                                  },
                                  () {},
                                ],
                              );
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 105.w,
                                  height: 105.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dmLightGrey,
                                    border: Border.all(
                                      color: dmDarkGrey,
                                      width: 1.w,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 73.h,
                                  left: 73.w,
                                  child: Container(
                                    width: 32.w,
                                    height: 32.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: dmWhite,
                                      border: Border.all(
                                        color: dmLightGrey,
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/images/icons/icon_camera.png',
                                        width: 15.w,
                                        height: 12.h,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Text(
                        '닉네임(12자 이내)',
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
                        controller: nickNameController,
                        cursorHeight: 24.h,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(12),
                        ],
                        style: welcomeInputTextDeco,
                        decoration: welcomeInputDeco,
                        cursorColor: dmBlack,
                      ),

                      // Bottom
                      const Expanded(child: SizedBox()),
                      nickNameController.text.length <= 12
                          ? GestureDetector(
                              onTap: () {
                                context.goNamed('accountSettingDone');
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
