// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';

import '../../../main.dart';

class MyHistoryScreen extends StatelessWidget {
  String history;

  MyHistoryScreen({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 키보드 위에 입력 창 띄우기 여부
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Title
            MainAppbar.show(
              title: history == 'posts' ? '판매내역' : '관심목록',
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
              action: const SizedBox(),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('user')
                        .doc('$uid')
                        .get(),
                    builder: (context, userData) {
                      debugPrint(userData.data?.data()?[history].toString());
                      Future<List<DocumentSnapshot>>
                          getProductDocuments() async {
                        List<dynamic>? historyData = [];
                        historyData = userData.data
                            ?.data()?[history]; // 검색할 product_id 배열
                        List<DocumentSnapshot> documents = [];

                        if (historyData != null) {
                          for (String productId in historyData.reversed) {
                            QuerySnapshot snapshot = await FirebaseFirestore
                                .instance
                                .collection('product')
                                .where('product_id', isEqualTo: productId)
                                .get();

                            documents.addAll(snapshot.docs);
                          }
                        }

                        return documents;
                      }

                      return FutureBuilder(
                        future: getProductDocuments(),
                        builder: (context, snapshot) {
                          // 만약 불러오는 상태라면 로딩 인디케이터를 중앙에 배치
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          }

                          // 데이터가 존재한다면
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            // 안드로이드 스와이프 Glow 애니메이션 제거
                            return ScrollConfiguration(
                              behavior: MyBehavior(),
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.length,
                                separatorBuilder: (context, index) => divider,
                                itemBuilder: (context, index) {
                                  // 가격 포맷
                                  String price = '';
                                  if (int.parse(
                                          snapshot.data![index]['price']) >=
                                      10000) {
                                    if (int.parse(snapshot.data![index]
                                                ['price']) %
                                            10000 ==
                                        0) {
                                      price =
                                          '${NumberFormat('#,###').format(int.parse(snapshot.data![index]['price']) ~/ 10000)}만원';
                                    } else {
                                      price =
                                          '${NumberFormat('#,###').format(int.parse(snapshot.data![index]['price']) ~/ 10000)}만 ${NumberFormat('#,###').format(int.parse(snapshot.data![index]['price']) % 10000)}원';
                                    }
                                  } else {
                                    price =
                                        '${NumberFormat('#,###').format(int.parse(snapshot.data![index]['price']))}원';
                                  }

                                  return Padding(
                                    // 첫번째 요소에만 윗부분 padding을 추가적으로 줌
                                    padding: index == 0
                                        ? EdgeInsets.only(
                                            top: 30.5.h, bottom: 17.5.h)
                                        : EdgeInsets.symmetric(
                                            vertical: 17.5.h),
                                    child: GestureDetector(
                                      // 요소 클릭 시 요소의 product_id를 DetailScreen으로 넘겨 이동
                                      onTap: () {
                                        context.pushNamed('detail',
                                            queryParams: {
                                              'productId': snapshot.data![index]
                                                  ['product_id']
                                            });
                                      },
                                      child: Container(
                                        color: dmWhite,
                                        // 기존 113.w에서 디바이스의 0.312배의 너비 값으로 변경
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.312,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                CachedNetworkImage(
                                                  fadeInDuration: Duration.zero,
                                                  fadeOutDuration:
                                                      Duration.zero,
                                                  imageUrl:
                                                      snapshot.data![index]
                                                          ['images'][0],
                                                  fit: BoxFit.cover,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.312,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.312,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.r),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      color: dmGrey,
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const CupertinoActivityIndicator(),
                                                ),
                                                snapshot.data![index]
                                                                ['status'] ==
                                                            1 ||
                                                        snapshot.data![index]
                                                                ['status'] ==
                                                            2
                                                    ? Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.312,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.312,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.r),
                                                          color: dmBlack
                                                              .withOpacity(
                                                                  0.75),
                                                        ),
                                                        child: Center(
                                                          child: snapshot.data![
                                                                          index]
                                                                      [
                                                                      'status'] ==
                                                                  1
                                                              ? Image.asset(
                                                                  'assets/images/status/status_1.png',
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.312 *
                                                                      0.9,
                                                                )
                                                              : Image.asset(
                                                                  'assets/images/status/status_2.png',
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.312 *
                                                                      0.9,
                                                                ),
                                                        ),
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 17.w,
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      child: Text(
                                                        snapshot.data![index]
                                                            ['title'],
                                                        overflow: TextOverflow
                                                            .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Pretendard',
                                                          fontSize: 17.sp,
                                                          fontWeight: medium,
                                                          color: dmBlack,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 11.h,
                                                    ),
                                                    Text(
                                                      '${snapshot.data![index]['location']} | ${DateFormat('yy.MM.dd').format((snapshot.data![index]['uploadTime'].toDate()))}',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontSize: 14.sp,
                                                        fontWeight: medium,
                                                        color: dmGrey,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 9.h,
                                                    ),
                                                    Text(
                                                      price,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Pretendard',
                                                        fontSize: 16.sp,
                                                        fontWeight: bold,
                                                        color: dmBlue,
                                                      ),
                                                    ),
                                                    const Expanded(
                                                        child: SizedBox()),
                                                    // likes가 1개 이상일 때만 표시
                                                    Visibility(
                                                      maintainSize: true,
                                                      maintainAnimation: true,
                                                      maintainState: true,
                                                      visible: snapshot
                                                                  .data![index]
                                                                      ['likes']
                                                                  .length >
                                                              0
                                                          ? true
                                                          : false,
                                                      child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/icons/icon_heart.png',
                                                              width: 13.w,
                                                            ),
                                                            SizedBox(
                                                              width: 5.5.w,
                                                            ),
                                                            Text(
                                                              '${snapshot.data![index]['likes'].length}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Pretendard',
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    bold,
                                                                color: dmGrey,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          // 데이터가 존재하지 않는다면
                          else {
                            return Center(
                              child: Text(
                                '검색과 일치하는 게시글이 없어요.',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 14.sp,
                                  fontWeight: bold,
                                  color: dmLightGrey,
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
