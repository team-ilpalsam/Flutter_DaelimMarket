import 'dart:convert';

import 'package:daelim_market/const/common.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CafeteriaStudentScreen extends StatelessWidget {
  CafeteriaStudentScreen({super.key});

  final dio = Dio();
  final DateTime now = DateTime.now();
  late final PageController pageController = PageController(
      initialPage: now.weekday < 6 ? now.weekday - 1 : 0,
      viewportFraction: 0.85);

  Future<Object?> getData() async {
    try {
      final dateData = await dio.get(
        'https://www.daelim.ac.kr/ajaxf/FrBistroSvc/BistroDateInfo.do',
      );

      if (dateData.data != null) {
        final currentWeekMonday =
            jsonDecode(dateData.data)['data'][0]['CURRENT_WEEK_MON_DAY'];
        final currentWeekFriday =
            jsonDecode(dateData.data)['data'][0]['CURRENT_WEEK_FRI_DAY'];

        final menuData = await dio.get(
          'https://www.daelim.ac.kr/ajaxf/FrBistroSvc/BistroCarteInfo.do?pageNo=1&MENU_ID=1470&BISTRO_SEQ=1&START_DAY=$currentWeekMonday&END_DAY=$currentWeekFriday',
        );

        return jsonDecode(menuData.data);
      }
    } catch (e) {
      debugPrint(e.toString());
      WarningSnackBar.show(
        text: '학생식당 정보를 불러오는 중 실패했습니다.',
        paddingBottom: 0,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight);

          /// 섹션 위젯
          Widget section(data, index) {
            String menu = '';
            int blank = 0;

            for (int i = 1; i < 10; i++) {
              if (data['data']['CCT$index$i'] != null &&
                  data['data']['CCT$index$i'] != '') {
                menu += '[${data['data']['CNM1$i']}]\n';
                menu +=
                    '${data['data']['CCT$index$i'].replaceAll('\r', '').trim()}\n\n';
              } else {
                blank++;
              }
            }

            if (blank >= 9) {
              menu += '메뉴가 없습니다.';
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.78358,
                  height: size.height * 0.86071,
                  decoration: BoxDecoration(
                    color: dmWhite,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: [
                      BoxShadow(
                        color: dmBlack.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 10.h,
                        offset: Offset(0, 10.h),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.03129,
                      ),
                      Text(
                        weekdayList[index - 1],
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 24.sp,
                          fontWeight: bold,
                          color: dmBlack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: size.height * 0.04694,
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: MyBehavior(),
                          child: SingleChildScrollView(
                            child: Text(
                              menu,
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 14.sp,
                                fontWeight: medium,
                                color: dmBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      child: ScrollConfiguration(
                        behavior: MyBehavior(),
                        child: Padding(
                          padding: EdgeInsets.only(top: size.height * 0.06259),
                          child: PageView(
                            controller: pageController,
                            children: [
                              ...List.generate(
                                5,
                                (index) => section(snapshot.data, index + 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
