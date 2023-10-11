import 'package:daelim_market/screen/main/school/announcement/announcement_administrative_screen.dart';
import 'package:daelim_market/screen/main/school/announcement/announcement_bachelor_screen.dart';
import 'package:daelim_market/screen/main/school/announcement/announcement_scholarship_screen.dart';
import 'package:daelim_market/screen/main/school/cafeteria/cafeteria_profstaff_screen.dart';
import 'package:daelim_market/screen/main/school/cafeteria/cafeteria_student_screen.dart';
import 'package:daelim_market/screen/main/school/schedule/schedule_screen.dart';
import 'package:daelim_market/screen/main/school/schoolbus/schoolbus_anyang_screen.dart';
import 'package:daelim_market/screen/main/school/schoolbus/schoolbus_beomgye_screen.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolScreen extends StatelessWidget {
  SchoolScreen({super.key});

  // 홈페이지는 무조건 마지막에
  final List<String> list = [
    '학생식당',
    '교직원식당',
    '셔틀버스\n(안양역)',
    '셔틀버스\n(범계역)',
    '학사일정',
    '학사공지',
    '장학공지',
    '행정공지',
    '홈페이지',
  ];

  final RxInt pageIndex = 0.obs;

  late final PageController pageController = PageController();

  void onTapPage(int index) async {
    if (index != list.length - 1) {
      pageController.jumpToPage(index);
    } else {
      Uri url = Uri.parse('http://daelim.ac.kr/');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    }
  }

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
    pageIndex.value = 0;
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
                '우리 학교 정보',
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 28.sp,
                  fontWeight: bold,
                  color: dmBlack,
                ),
                textAlign: TextAlign.center,
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
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            onTapPage(index);
                          },
                          child: Obx(
                            () => Container(
                              height:
                                  MediaQuery.of(context).size.height * 0.07042,
                              color:
                                  pageIndex.value == index ? dmWhite : dmBlue,
                              child: Center(
                                child: Text(
                                  list[index],
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16.sp,
                                    fontWeight: semiBold,
                                    color: pageIndex.value == index
                                        ? dmBlack
                                        : dmWhite,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: PageView(
                        scrollDirection: Axis.vertical,
                        controller: pageController,
                        children: [
                          CafeteriaStudentScreen(),
                          CafeteriaProfstaffScreen(),
                          SchoolbusAnyangScreen(),
                          SchoolbusBeomgyeScreen(),
                          ScheduleScreen(),
                          AnnouncementBachelorScreen(),
                          AnnouncementScholarshipScreen(),
                          AnnouncementAdministrativeScreen(),
                        ],
                        onPageChanged: (value) {
                          pageIndex.value = value;
                        },
                      ),
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
