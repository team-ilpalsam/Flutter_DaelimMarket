import 'package:flutter/material.dart';

// 안드로이드 스크롤 Glow 애니메이션 삭제
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
