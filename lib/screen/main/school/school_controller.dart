import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchoolController extends GetxController {
  RxInt pageIndex = 0.obs;

  // 홈페이지는 무조건 마지막에
  List<String> list = [
    '학생식당',
    '교직원식당',
    '셔틀버스',
    '학사일정',
    '학사공지',
    '장학공지',
    '홈페이지',
  ];

  late final PageController pageController =
      PageController(initialPage: pageIndex.value);

  void changePage(int index) {
    if (index != list.length - 1) {
      pageController.jumpToPage(index);
    }
  }
}
