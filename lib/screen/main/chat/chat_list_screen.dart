import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
                '채팅',
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: 8,
                    separatorBuilder: (context, index) => divider,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: index == 0
                            ? EdgeInsets.only(top: 34.5.h, bottom: 30.h)
                            : EdgeInsets.symmetric(vertical: 30.h),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            color: dmWhite,
                            height: MediaQuery.of(context).size.width * 0.21119,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width *
                                      0.21119,
                                  height: MediaQuery.of(context).size.width *
                                      0.21119,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: dmBlue,
                                  ),
                                ),
                                SizedBox(
                                  width: 22.w,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'HUGESILVER',
                                        overflow: TextOverflow
                                            .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 28.sp,
                                          fontWeight: medium,
                                          color: dmBlack,
                                        ),
                                      ),
                                      Text(
                                        '외부와 내부 다 깨끗하고 하자는 없습니다.',
                                        overflow: TextOverflow
                                            .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 18.sp,
                                          fontWeight: medium,
                                          color: dmDarkGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
