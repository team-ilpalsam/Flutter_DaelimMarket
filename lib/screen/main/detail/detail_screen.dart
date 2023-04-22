import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daelim_market/screen/widgets/alert_dialog.dart';
import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../styles/fonts.dart';
import '../../widgets/snackbar.dart';

class DetailScreen extends StatefulWidget {
  final String productId;

  const DetailScreen({super.key, required this.productId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? uid;

  _asyncMethod() async {
    uid = await const FlutterSecureStorage().read(key: "uid");
  }

  @override
  Widget build(BuildContext context) {
    _asyncMethod();
    return Scaffold(
      backgroundColor: dmWhite,
      body: SafeArea(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('product')
              .doc(widget.productId)
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
                  MainAppbar.show(
                    title: snapshot.data!['title'],
                    leading: GestureDetector(
                      onTap: () {
                        context.go('/main');
                      },
                      child: Image.asset(
                        'assets/images/icons/icon_back.png',
                        alignment: Alignment.topLeft,
                        height: 18.h,
                      ),
                    ),
                    action: snapshot.data!['uid'] == uid
                        ? GestureDetector(
                            onTap: () {
                              AlertDialogWidget.twoButtons(
                                context: context,
                                content: "정말로 삭제하시겠습니까?",
                                button: ["취소", "삭제할래요."],
                                color: [dmGrey, dmRed],
                                action: [
                                  () {
                                    Navigator.pop(context);
                                  },
                                  () async {
                                    Navigator.pop(context);
                                    try {
                                      await Future.wait([
                                        FirebaseFirestore.instance
                                            .collection('product')
                                            .doc(snapshot.data!['product_id'])
                                            .delete(),
                                        FirebaseFirestore.instance
                                            .collection('user')
                                            .doc(uid)
                                            .update({
                                          'posts': FieldValue.arrayRemove(
                                              [snapshot.data!['product_id']])
                                        })
                                      ]);

                                      context.go('/main');
                                      DoneSnackBar.show(
                                        context: context,
                                        text: '판매글을 삭제했어요.',
                                        paddingHorizontal: 0,
                                        paddingBottom: 0,
                                      );
                                    } catch (e) {
                                      context.go('/main');
                                      WarningSnackBar.show(
                                        context: context,
                                        text: '판매글 삭제 중 문제가 생겼어요.',
                                        paddingHorizontal: 0,
                                        paddingBottom: 0,
                                      );
                                      debugPrint(e.toString());
                                    }
                                  }
                                ],
                              );
                            },
                            child: Text(
                              "삭제",
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 18.sp,
                                fontWeight: medium,
                                color: dmRed,
                              ),
                            ),
                          )
                        : const SizedBox(),
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
                            child: Column(
                              children: [
                                CarouselSlider(
                                  items: List<Widget>.from(
                                    snapshot.data!['images']
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      String value = entry.value;
                                      int index = entry.key;
                                      return GestureDetector(
                                        onTap: () {
                                          context.pushNamed(
                                            'imageviewer',
                                            queryParams: {'src': value},
                                          );
                                        },
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                              height: 351.h,
                                              child: Image.network(
                                                value,
                                                width: 351.w,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            snapshot.data!['images'].length > 1
                                                ? Positioned(
                                                    left: 10.w,
                                                    bottom: 10.h,
                                                    child: Container(
                                                      width: 75.w,
                                                      height: 30.h,
                                                      decoration: BoxDecoration(
                                                        color: dmBlack
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    3.40e+38),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '${index + 1} / ${snapshot.data!['images'].length}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  medium,
                                                              color:
                                                                  dmLightGrey),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                  options: CarouselOptions(
                                    viewportFraction: 1,
                                    autoPlay: false,
                                    enableInfiniteScroll: false,
                                    height: 351.h,
                                  ),
                                ),
                              ],
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
                  Container(
                    width: double.infinity,
                    height: 60.5.h,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: dmGrey,
                          width: 1.w,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 10.h,
                        left: 32.w,
                        right: 20.w,
                        bottom: window.viewPadding.bottom > 0 ? 0 : 32.h,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              snapshot.data!['likes'].contains(uid)
                                  ? GestureDetector(
                                      onTap: () async {
                                        try {
                                          await Future.wait(
                                            [
                                              FirebaseFirestore.instance
                                                  .collection('product')
                                                  .doc(snapshot
                                                      .data!['product_id'])
                                                  .update({
                                                'likes': FieldValue.arrayRemove(
                                                    [uid!])
                                              }),
                                              FirebaseFirestore.instance
                                                  .collection('user')
                                                  .doc(uid)
                                                  .update(
                                                {
                                                  'watchlist':
                                                      FieldValue.arrayRemove([
                                                    snapshot.data!['product_id']
                                                  ])
                                                },
                                              ),
                                            ],
                                          );
                                          setState(() {});
                                        } catch (e) {
                                          WarningSnackBar.show(
                                            context: context,
                                            text: '관심을 누르던 중 문제가 생겼어요.',
                                            paddingHorizontal: 0,
                                          );
                                          debugPrint(e.toString());
                                        }
                                      },
                                      child: Image.asset(
                                        'assets/images/icons/icon_heart_fill.png',
                                        height: 27.h,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        try {
                                          await Future.wait(
                                            [
                                              FirebaseFirestore.instance
                                                  .collection('product')
                                                  .doc(snapshot
                                                      .data!['product_id'])
                                                  .update({
                                                'likes': FieldValue.arrayUnion(
                                                    [uid!])
                                              }),
                                              FirebaseFirestore.instance
                                                  .collection('user')
                                                  .doc(uid)
                                                  .update(
                                                {
                                                  'watchlist':
                                                      FieldValue.arrayUnion([
                                                    snapshot.data!['product_id']
                                                  ])
                                                },
                                              ),
                                            ],
                                          );
                                          setState(() {});
                                        } catch (e) {
                                          WarningSnackBar.show(
                                            context: context,
                                            text: '관심을 누르던 중 문제가 생겼어요.',
                                            paddingHorizontal: 0,
                                          );
                                          debugPrint(e.toString());
                                        }
                                      },
                                      child: Image.asset(
                                        'assets/images/icons/icon_heart.png',
                                        height: 27.h,
                                      ),
                                    ),
                              SizedBox(
                                width: 21.83.w,
                              ),
                              Container(
                                width: 1.w,
                                height: 36.h,
                                color: dmDarkGrey,
                              ),
                              SizedBox(
                                width: 20.5.w,
                              ),
                              Text(
                                '${NumberFormat('#,###').format(int.parse(snapshot.data!['price']))}원',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 21.sp,
                                  fontWeight: bold,
                                  color: dmBlue,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 115.w,
                            height: 34.h,
                            decoration: BoxDecoration(
                              color: dmLightGrey,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: Center(
                              child: Text(
                                '채팅하기',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 16.sp,
                                  fontWeight: bold,
                                  color: dmWhite,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
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
