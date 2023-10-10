import 'dart:convert';

import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleScreen extends StatelessWidget {
  ScheduleScreen({super.key});

  final dio = Dio();
  final DateTime now = DateTime.now();
  late final PageController pageController = PageController(
      initialPage: now.month > 2 ? now.month - 3 : now.month + 10,
      viewportFraction: 0.85);

  Future<Object?> getScheduleData() async {
    try {
      final String scheduleDataUrl =
          'https://www.daelim.ac.kr/ajaxf/FrScheduleSvc/ScheduleData.do?SCH_YEAR=${now.month < 3 ? now.year - 1 : now.year}&SCH_DEPT_CD=2';

      final scheduleDataResponse = await dio.get(scheduleDataUrl);

      final scheduleData = jsonDecode(scheduleDataResponse.data);

      return scheduleData;
    } catch (e) {
      debugPrint('getScheduleData: ${e.toString()}');
      WarningSnackBar.show(
        text: '학사일정 정보를 불러오는 중 실패했습니다.',
        paddingBottom: 0,
      );
    }
    return null;
  }

  Future<Object?> getScheduleListData() async {
    try {
      final String scheduleListDataUrl =
          'https://www.daelim.ac.kr/ajaxf/FrScheduleSvc/ScheduleListData.do?SCH_YEAR=${now.year - (now.month < 3 ? 2 : 1)}&SCH_DEPT_CD=2';

      final scheduleListDataResponse = await dio.get(scheduleListDataUrl);
      final scheduleListData = jsonDecode(scheduleListDataResponse.data);

      return scheduleListData;
    } catch (e) {
      debugPrint(e.toString());
      WarningSnackBar.show(
        text: '학사일정 정보를 불러오는 중 실패했습니다.',
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
          Widget section(scheduleData, scheduleListData, month) {
            List uniqueSubject = [];
            List uniquifiedScheduleListData = [];

            String message = '';

            if (scheduleData['data'] != null &&
                scheduleListData['data'] != null) {
              String convertFromYMD(String ymd) {
                String yyyy = ymd.substring(0, 4); // 연도
                String mm = ymd.substring(4, 6); // 월
                String dd = ymd.substring(6, 8); // 일
                return '$yyyy.$mm.$dd';
              }

              // SUBJECT 단일화

              for (var sd in scheduleData['data']) {
                if (sd["SUBJECT"] != null) {
                  uniqueSubject.add(sd["SUBJECT"]);
                }
              }

              for (var sld in scheduleListData['data']) {
                if (sld["SUBJECT"] != null &&
                    !uniqueSubject.contains(sld["SUBJECT"])) {
                  uniquifiedScheduleListData.add(sld);
                }
              }

              List<Map<String, dynamic>> stackSubject = [];

              for (int i = 0; i < scheduleData['data'].length; i++) {
                if (scheduleData['data'][i]["SUBJECT"] != null) {
                  if (i < scheduleData['data'].length - 1) {
                    if (scheduleData['data'][i + 1]["SUBJECT"] != null &&
                        scheduleData['data'][i]["SUBJECT"] ==
                            scheduleData['data'][i + 1]["SUBJECT"]) {
                      stackSubject.add(scheduleData['data'][i]);
                    } else {
                      if (stackSubject.isNotEmpty) {
                        if (scheduleData['data'][i]["SUBJECT"] ==
                            stackSubject[stackSubject.length - 1]["SUBJECT"]) {
                          stackSubject.add(scheduleData['data'][i]);
                          if (stackSubject[0]["M"] == month ||
                              stackSubject[stackSubject.length - 1]["M"] ==
                                  month) {
                            message +=
                                "[${convertFromYMD(stackSubject[0]['FROM_YMD'])}~${convertFromYMD(stackSubject[stackSubject.length - 1]['FROM_YMD'])}]\n${stackSubject[0]['SUBJECT']}\n\n";
                            stackSubject = [];
                          } else {
                            stackSubject = [];
                          }
                        }
                      } else {
                        if (scheduleData['data'][i]["M"] == month) {
                          message +=
                              "[${convertFromYMD(scheduleData['data'][i]['FROM_YMD'])}]\n${scheduleData['data'][i]['SUBJECT']}\n\n";
                        }
                      }
                    }
                  } else {
                    if (stackSubject.isNotEmpty) {
                      if (scheduleData['data'][i - 1]["SUBJECT"] != null &&
                          scheduleData['data'][i]["SUBJECT"] ==
                              scheduleData['data'][i - 1]["SUBJECT"]) {
                        stackSubject.add(scheduleData['data'][i]);
                        if (stackSubject[0]["M"] == month ||
                            stackSubject[stackSubject.length - 1]["M"] ==
                                month) {
                          message +=
                              "[${convertFromYMD(stackSubject[0]['FROM_YMD'])}~${convertFromYMD(stackSubject[stackSubject.length - 1]['FROM_YMD'])}]\n${stackSubject[0]['SUBJECT']}\n\n";
                          stackSubject = [];
                        } else {
                          stackSubject = [];
                        }
                      }
                    } else {
                      if (scheduleData['data'][i]["M"] == month) {
                        message +=
                            "[${convertFromYMD(scheduleData['data'][i]['FROM_YMD'])}]\n${scheduleData['data'][i]['SUBJECT']}\n\n";
                      }
                    }
                  }
                }
              }

              for (var item in uniquifiedScheduleListData) {
                if (int.parse(item['START_M']) <= month &&
                    month <= int.parse(item['END_M']) &&
                    int.parse(item['START_Y']) <= now.year &&
                    now.year <= int.parse(item['END_Y'])) {
                  if (item['START_D'] == item['END_D'] &&
                      item['START_M'] == item['END_M'] &&
                      item['START_Y'] == item['END_Y']) {
                    message +=
                        "[${item['END_Y']}.${item['END_M']}.${item['END_D']}]\n${item['SUBJECT']}\n\n";
                  } else {
                    message +=
                        "[${item['START_Y']}.${item['START_M']}.${item['START_D']}~${item['END_Y']}.${item['END_M']}.${item['END_D']}]\n${item['SUBJECT']}\n\n";
                  }
                }
              }

              if (message == '') {
                message += '일정이 없습니다.';
              }
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.78358,
                  height: size.height * 0.83098,
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
                        '${month < 3 ? now.year + 1 : now.year}년 $month월',
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
                        child: SingleChildScrollView(
                          child: Text(
                            message,
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
                    ],
                  ),
                ),
              ],
            );
          }

          return FutureBuilder(
            future: getScheduleData(),
            builder: (context, scheduleData) {
              if (scheduleData.hasData) {
                return FutureBuilder(
                  future: getScheduleListData(),
                  builder: (context, scheduleListData) {
                    if (scheduleListData.hasData) {
                      return Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.05477,
                          ),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                PageView(
                                  controller: pageController,
                                  children: [
                                    ...List.generate(
                                      12,
                                      (index) => section(
                                          scheduleData.data,
                                          scheduleListData.data,
                                          index < 10 ? index + 3 : index - 9),
                                    ),
                                  ],
                                  onPageChanged: (value) {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
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
