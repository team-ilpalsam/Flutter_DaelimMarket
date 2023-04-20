import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatelessWidget {
  final String productId;

  const DetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dmWhite,
      body: SafeArea(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('product')
              .doc(productId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (snapshot.hasData && snapshot.data!.data()!.isNotEmpty) {
              return Column(
                children: [
                  topPadding,
                  MainAppbar.show(
                    title: snapshot.data!['title'],
                    leading: GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Image.asset(
                        'assets/images/icons/icon_back.png',
                        alignment: Alignment.topLeft,
                        height: 18.h,
                      ),
                    ),
                    action: const SizedBox(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 18.5.h,
                          ),
                          Center(
                            child: CarouselSlider(
                              items: List<Widget>.from(
                                snapshot.data!['images'].map(
                                  (value) => SizedBox(
                                    child: Image.network(
                                      value,
                                      width: 351.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              options: CarouselOptions(
                                viewportFraction: 1,
                                autoPlay: false,
                                enableInfiniteScroll: false,
                                height: 351.h,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 19.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  //상세페이지 제목
                                  child: Text(
                                    snapshot.data!['title'],
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      color: dmBlack,
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                SizedBox(
                                  //닉네임 + 건물
                                  child: Text(
                                    '${snapshot.data!['id'].toUpperCase()} · ${snapshot.data!['location']}', //전산관이랑 따로 해야하겠지? 잠시 보류
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      color: dmDarkGrey,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 22.h,
                                ),
                                snapshot.data!['desc'] != ''
                                    ? SizedBox(
                                        //상세페이지 내용
                                        child: Text(
                                          snapshot.data!['desc'],
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            color: dmBlack,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                snapshot.data!['desc'] != ''
                                    ? SizedBox(
                                        height: 22.h,
                                      )
                                    : const SizedBox(),
                                SizedBox(
                                  //하단 날짜
                                  child: Text(
                                    DateFormat('y년 MMM d일 a h시 mm분', 'ko_KR')
                                        .format(snapshot.data!['uploadTime']
                                            .toDate()),
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      color: dmDarkGrey,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
