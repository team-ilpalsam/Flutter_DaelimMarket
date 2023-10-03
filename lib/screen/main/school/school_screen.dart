import 'package:daelim_market/screen/main/school/school_controller.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SchoolScreen extends StatelessWidget {
  SchoolScreen({super.key});

  final SchoolController _controller = Get.put(SchoolController());

  Widget block(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: dmLightGrey,
        child: Center(
            child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 18.sp,
            fontWeight: medium,
            color: dmBlack,
          ),
        )),
      ),
    );
  }

  Widget selectedBlock(String text) {
    return Container(
      color: dmWhite,
      child: Center(
          child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 18.sp,
          fontWeight: medium,
          color: dmBlack,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            topPadding,
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: Text(
                '마이페이지',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 28.sp,
                  fontWeight: bold,
                  color: dmBlack,
                ),
              ),
            ),
            SizedBox(height: 17.5.h),
            divider,

            // Content
            const Row(
              children: [
                // SideMenu(
                //   items: [],
                //   controller: controller,
                // ),
                // Expanded(
                //   child: PageView(),
                // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
