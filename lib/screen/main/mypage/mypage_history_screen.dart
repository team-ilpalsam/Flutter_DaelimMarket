import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:daelim_market/const/common.dart';
import 'package:daelim_market/main.dart';
import 'package:daelim_market/screen/main/mypage/mypage_controller.dart';
import 'package:daelim_market/screen/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:daelim_market/screen/widgets/main_appbar.dart';
import 'package:daelim_market/screen/widgets/named_widget.dart';
import 'package:daelim_market/screen/widgets/scroll_behavior.dart';
import 'package:daelim_market/styles/colors.dart';
import 'package:daelim_market/styles/fonts.dart';

class MyHistoryScreen extends StatelessWidget {
  final String history;

  MyHistoryScreen({
    super.key,
    required this.history,
  });

  final MypageController _controller = Get.put(MypageController());

  final RxInt stack = 0.obs;
  final int limit = 5;

  final RxList keys = [].obs;
  final RxList list = [].obs;

  // 데이터 리스트 가져오기
  void getData() async {
    if (history == 'posts') {
      keys.value = _controller.myPostsKeys;
    } else {
      keys.value = _controller.myWatchlistKeys;
    }

    if (keys.isNotEmpty) {
      if (keys.length > (stack.value * limit)) {
        List tempList = [];
        try {
          for (var i = (stack.value * limit);
              i <
                  (keys.length >= (stack.value + 1) * limit
                      ? (stack.value + 1) * limit
                      : keys.length);
              i++) {
            await FirebaseFirestore.instance
                .collection('product')
                .doc(keys[i])
                .get()
                .then((value) async {
              if (value.data() != null) {
                tempList.add(value);
              } else {
                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(uid)
                    .update({
                  history: FieldValue.arrayRemove([keys[i]]),
                });
              }
            });
          }
          stack.value++;
          list.value += tempList;
        } catch (e) {
          WarningSnackBar.show(
              text: '데이터를 불러오는 중 오류가 발생하였습니다.', paddingBottom: 0);
          debugPrint(e.toString());
        }
      }
    } else {
      debugPrint('history의 list가 비어있음');
    }
  }

  // refresh 함수
  Future<void> onRefresh() async {
    stack.value = 0;
    list.value = [];

    _controller.getMyData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Title
            MainAppbar.show(
              title: history == 'posts' ? '판매내역' : '관심목록',
              leading: GestureDetector(
                onTap: () {
                  Get.back();
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
                child: CustomRefreshIndicator(
                  onRefresh: onRefresh,
                  builder: (context, child, controller) {
                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        if (!controller.isIdle)
                          Positioned(
                            top: 40.h * controller.value,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 20.h,
                              ),
                              child: CupertinoActivityIndicator(
                                animating: !controller.isDragging,
                              ),
                            ),
                          ),
                        Transform.translate(
                          offset: Offset(0, 40.h * controller.value),
                          child: child,
                        ),
                      ],
                    );
                  },
                  child: Obx(
                    () => ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: list.isNotEmpty
                          ? NotificationListener(
                              onNotification:
                                  (ScrollNotification notification) {
                                if (notification is ScrollEndNotification &&
                                    notification.metrics.maxScrollExtent ==
                                        notification.metrics.pixels) {
                                  getData();
                                }
                                return false;
                              },
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                itemCount: list.length,
                                separatorBuilder: (context, index) => divider,
                                itemBuilder: (context, index) {
                                  if (list.isNotEmpty) {
                                    if (list[index] != null) {
                                      return Padding(
                                        // 첫번째 요소에만 윗부분 padding을 추가적으로 줌
                                        padding: index == 0
                                            ? EdgeInsets.only(
                                                top: 30.5.h, bottom: 17.5.h)
                                            : EdgeInsets.symmetric(
                                                vertical: 17.5.h),
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              // 요소 클릭 시 요소의 product_id를 DetailScreen으로 넘겨 이동
                                              onTap: () {
                                                Get.toNamed(
                                                  '/detail',
                                                  parameters: {
                                                    'productId': list[index]
                                                        ['product_id'],
                                                  },
                                                );
                                              },
                                              child: Container(
                                                color: dmWhite,
                                                // 기존 113.w에서 디바이스의 0.312배의 너비 값으로 변경
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.312,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Stack(
                                                      children: [
                                                        CachedNetworkImage(
                                                          fadeInDuration:
                                                              Duration.zero,
                                                          fadeOutDuration:
                                                              Duration.zero,
                                                          imageUrl: list[index]
                                                              ['images'][0],
                                                          fit: BoxFit.cover,
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
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.r),
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                              color: dmGrey,
                                                            ),
                                                          ),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const CupertinoActivityIndicator(),
                                                          errorWidget: (context,
                                                              url, error) {
                                                            return Center(
                                                              child: Text(
                                                                '등록된 이미지가 없어요.',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Pretendard',
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      bold,
                                                                  color:
                                                                      dmLightGrey,
                                                                ),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                        list[index]['status'] ==
                                                                    1 ||
                                                                list[index][
                                                                        'status'] ==
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
                                                                  child: list[index]
                                                                              [
                                                                              'status'] ==
                                                                          1
                                                                      ? Image
                                                                          .asset(
                                                                          'assets/images/status/status_1.png',
                                                                          width: MediaQuery.of(context).size.width *
                                                                              0.312 *
                                                                              0.9,
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          'assets/images/status/status_2.png',
                                                                          width: MediaQuery.of(context).size.width *
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
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              child: Text(
                                                                list[index]
                                                                    ['title'],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis, // Text가 overflow 현상이 일어나면 뒷부분을 ...으로 생략한다
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Pretendard',
                                                                  fontSize:
                                                                      17.sp,
                                                                  fontWeight:
                                                                      medium,
                                                                  color:
                                                                      dmBlack,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 11.h,
                                                            ),
                                                            Text(
                                                              '${list[index]['location']} | ${DateFormat('yy.MM.dd').format((list[index]['uploadTime'].toDate()))}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Pretendard',
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    medium,
                                                                color: dmGrey,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 9.h,
                                                            ),
                                                            Text(
                                                              formatPrice(list[
                                                                      index]
                                                                  ['price']),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Pretendard',
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    bold,
                                                                color: dmBlue,
                                                              ),
                                                            ),
                                                            const Expanded(
                                                                child:
                                                                    SizedBox()),
                                                            // likes가 1개 이상일 때만 표시
                                                            Visibility(
                                                              maintainSize:
                                                                  true,
                                                              maintainAnimation:
                                                                  true,
                                                              maintainState:
                                                                  true,
                                                              visible: list[index]
                                                                              [
                                                                              'likes']
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
                                                                      width:
                                                                          13.w,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          5.5.w,
                                                                    ),
                                                                    Text(
                                                                      '${list[index]['likes'].length}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Pretendard',
                                                                        fontSize:
                                                                            14.sp,
                                                                        fontWeight:
                                                                            bold,
                                                                        color:
                                                                            dmGrey,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (list.length == index + 1 &&
                                                keys.length != index + 1 &&
                                                list.length >= limit) ...[
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 40.h,
                                                ),
                                                child:
                                                    const CupertinoActivityIndicator(),
                                              )
                                            ],
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                  return const SizedBox();
                                },
                              ),
                            )
                          :
                          // 데이터가 존재하지 않는다면
                          Center(
                              child: Text(
                                '아직 목록이 없어요.',
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 14.sp,
                                  fontWeight: bold,
                                  color: dmLightGrey,
                                ),
                              ),
                            ),
                    ),
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
