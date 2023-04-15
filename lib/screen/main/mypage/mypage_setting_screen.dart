import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class MypageSettingScreen extends StatefulWidget {
  final VoidCallback? onTap;

  const MypageSettingScreen({
    this.onTap,
    super.key,
  });

  @override
  State<MypageSettingScreen> createState() => _MypageSettingScreenState();
}

class _MypageSettingScreenState extends State<MypageSettingScreen> {
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
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 71.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: Image.asset(
                              'assets/images/icons/icon_back.png',
                              alignment: Alignment.topLeft,
                              height: 18.h,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "프로필 수정",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 22.sp,
                            fontWeight: medium,
                            color: dmBlack,
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                    SizedBox(
                      height: 56.h,
                    ),
                    Center(
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
                            left: 73.h,
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
                    SizedBox(
                      height: 18.h,
                    ),
                    Text(
                      "닉네임(12자 이내)",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18.sp,
                        fontWeight: medium,
                        color: dmBlack,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 40.h,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.w, color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "이메일",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18.sp,
                        fontWeight: medium,
                        color: dmBlack,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    SizedBox(
                      height: 40.h,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.w, color: Colors.blue),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Divider(
                      color: dmGrey,
                      thickness: 1.w,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/');
                      },
                      child: const Text(
                        "계정 삭제",
                        style: TextStyle(
                          color: dmLightGrey,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go('/');
                      },
                      child: const Text(
                        "로그아웃",
                        style: TextStyle(
                          color: dmLightGrey,
                        ),
                      ),
                    )
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
