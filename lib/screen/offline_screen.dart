import 'package:daelim_market/const/common.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:daelim_market/service/connection_service.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OfflineScreen extends StatelessWidget {
  OfflineScreen({super.key});

  final ConnectionService _connectionController = Get.put(ConnectionService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              textLessLogo,
              height: 157.w,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            '네트워크 연결이 끊어졌습니다.',
            overflow: TextOverflow
                .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
            maxLines: 2,
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 21.sp,
              fontWeight: semiBold,
              color: dmBlack,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          GestureDetector(
            onTap: () {
              if (_connectionController.isConnetected.value) {
                Get.offAllNamed('/');
              } else {
                WarningSnackBar.show(
                    text: '네트워크가 연결이 되지 않았어요.', paddingBottom: 0);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: dmBlue,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25.w,
                  vertical: 7.5.h,
                ),
                child: Text(
                  '재시도',
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 16.sp,
                    fontWeight: semiBold,
                    color: dmWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
