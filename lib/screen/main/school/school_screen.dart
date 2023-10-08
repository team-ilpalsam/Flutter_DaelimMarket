import 'package:daelim_market/screen/main/school/cafeteria/cafeteria_profstaff_screen.dart';
import 'package:daelim_market/screen/main/school/cafeteria/cafeteria_student_screen.dart';
import 'package:daelim_market/screen/main/school/school_controller.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
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
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.31806,
                      color: dmBlue,
                      child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: _controller.list.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _controller.pageIndex.value = index;
                              _controller.changePage(index);
                            },
                            child: Obx(
                              () => Container(
                                height: MediaQuery.of(context).size.height *
                                    0.07042,
                                color: _controller.pageIndex.value == index
                                    ? dmWhite
                                    : dmBlue,
                                child: Center(
                                  child: Text(
                                    _controller.list[index],
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 16.sp,
                                      fontWeight: semiBold,
                                      color:
                                          _controller.pageIndex.value == index
                                              ? dmBlack
                                              : dmWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                  Expanded(
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _controller.pageController,
                      children: const [
                        CafeteriaStudentScreen(),
                        CafeteriaProfstaffScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
